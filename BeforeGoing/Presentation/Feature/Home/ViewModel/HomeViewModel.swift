//
//  HomeViewModel.swift
//  BeforeGoing
//
//  Created by APPLE on 9/23/25.
//

import CoreLocation
import Foundation

protocol HomeOutput {}

final class HomeViewModel: ViewModeling {
    
    private static let seperator = ", "
    
    private let weatherUseCase: RequestWeatherType
    private let getMissionsUseCase: FetchMissionsType
    private let checkMissionUseCase: CheckMissionType
    private let addTodayMissionUseCase: AddTodayMissionType
    private let deleteTodayMissionUseCase: DeleteTodayMissionType
    
    private var missions: [(
        missionID: Int,
        content: String,
        initState: ListItemState,
        state: ListItemState,
        isChecked: Bool
    )] = []
    
    init(
        weatherUseCase: RequestWeatherType,
        getMissionsUseCase: FetchMissionsType,
        checkMissionUseCase: CheckMissionType,
        addTodayMissionUseCase: AddTodayMissionType,
        deleteTodayMissionUseCase: DeleteTodayMissionType
    ) {
        self.weatherUseCase = weatherUseCase
        self.getMissionsUseCase = getMissionsUseCase
        self.checkMissionUseCase = checkMissionUseCase
        self.addTodayMissionUseCase = addTodayMissionUseCase
        self.deleteTodayMissionUseCase = deleteTodayMissionUseCase
    }
    
    enum Input {
        case requestDate
        case requestWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
        case scenarioDidTap(scenarioID: Int, date: String)
        case missionChecked(missionID: Int, date: String)
        case addTodayMissionButtonDidTap(scenarioID: Int, date: String, content: String)
        case deleteTodayMissionButtonDidTap(missionID: Int)
    }
    
    typealias Output = HomeOutput
    
    struct DateOutput: HomeOutput {
        let date: String
    }
    
    struct WeatherOutput: HomeOutput {
        let weatherResult: NSMutableAttributedString
    }
    
    struct MissionsOutput: HomeOutput {
        let missionsResult: Result<MissionsEntity, Error>
    }
    
    struct TodayMissionOutput: HomeOutput {
        let todayMissionResult: Result<TodayMissionEntity, Error>
    }
    
    struct DeleteTodayMissionOutput: HomeOutput {
        let deleteTodayMissionResult: Result<Void, Error>
    }
    
    struct EmptyOutput: HomeOutput {}
    
    func action(input: Input) async throws -> Output {
        switch input {
        case .requestDate:
            let date = DateUtil.getCurrentDate(format: "yyyy년 MM월 dd일")
            return DateOutput(date: date)
            
        case .requestWeather(let latitude, let longitude) :
            let administrativeArea = try await getAdministrativeArea(
                latitude: latitude,
                longitude: longitude
            )
            let result = try await requestWeatherResult(
                latitude: latitude,
                longitude: longitude
            )
            let weatherResult = convertWeatherResult(
                administrativeArea: administrativeArea,
                result: result
            )
            return WeatherOutput(weatherResult: weatherResult)
            
        case .scenarioDidTap(let scenarioID, let date):
            do {
                let result = try await getMissionsUseCase.execute(
                    scenarioID: scenarioID,
                    date: date
                )
                missions.removeAll()
                
                result.todayMissions.forEach {
                    if $0.isChecked {
                        addMissionContent($0.missionId, $0.content, .today, .completed, $0.isChecked)
                        return
                    }
                    addMissionContent($0.missionId, $0.content, .today, .today, $0.isChecked)
                }
                result.basicMissions.forEach {
                    if $0.isChecked {
                        addMissionContent($0.missionId, $0.content, .normal, .completed, $0.isChecked)
                        return
                    }
                    addMissionContent($0.missionId, $0.content, .normal, .normal, $0.isChecked)
                }
                return MissionsOutput(missionsResult: .success(result))
            } catch {
                BeforeGoingLogger.error(error)
                return MissionsOutput(missionsResult: .failure(error))
            }
            
        case .missionChecked(let missionID, let date):
            do {
                try await checkMissionUseCase.execute(
                    missionID: missionID,
                    date: date,
                    isChecked: true
                )
                if let index = missions.firstIndex(where: { $0.missionID == missionID }) {
                    completeMission(at: index)
                }
            } catch {
                BeforeGoingLogger.error(error)
            }
            return EmptyOutput()
            
        case .addTodayMissionButtonDidTap(let scenarioID, let date, let content):
            do {
                let result = try await addTodayMissionUseCase.execute(
                    scenarioID: scenarioID,
                    date: date,
                    content: content
                )
                missions.insert(
                    (
                        missionID: result.missionId,
                        content: result.content,
                        initState: .today,
                        state: .today,
                        isChecked: result.isChecked
                    ),
                    at: 0
                )
                return TodayMissionOutput(todayMissionResult: .success(result))
            } catch {
                BeforeGoingLogger.error(error)
                return TodayMissionOutput(todayMissionResult: .failure(error))
            }
            
        case .deleteTodayMissionButtonDidTap(let missionID):
            do {
                try await deleteTodayMissionUseCase.execute(missionID: missionID)
                guard let index = missions.firstIndex(where: { $0.missionID == missionID }) else {
                    return DeleteTodayMissionOutput(
                        deleteTodayMissionResult: .failure(BeforeGoingError.missionNotFound)
                    )
                }
                missions.remove(at: index)
                return DeleteTodayMissionOutput(deleteTodayMissionResult: .success(Void()))
            } catch {
                BeforeGoingLogger.error(error)
                return DeleteTodayMissionOutput(deleteTodayMissionResult: .failure(error))
            }
        }
    }
    
    private func getAdministrativeArea(
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees
    ) async throws -> NSMutableAttributedString {
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let placemarks = try await CLGeocoder().reverseGeocodeLocation(location)
        let administrativeArea = placemarks.first?.administrativeArea ?? ""
        
        return administrativeArea.customText(rangedText: administrativeArea)
    }
    
    private func requestWeatherResult(
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees
    ) async throws -> WeatherEntity {
        
        let date: String = DateUtil.getCurrentDate(format: "yyyy-MM-dd")
        let timezone = TimeZone.current.identifier
        let result = try await weatherUseCase.execute(
            date: date,
            timezone: timezone,
            latitude: Float(latitude),
            longitude: Float(longitude)
        )
        
        return result
    }
    
    private func convertWeatherResult(
        administrativeArea: NSMutableAttributedString,
        result: WeatherEntity
    ) -> NSMutableAttributedString {
        
        let weatherInformation = makeString(result.mapInformation())
        let supplies = makeString(result.mapSupplies())
        
        let weatherResult = NSMutableAttributedString()
        
        weatherResult.do {
            $0.append(administrativeArea)
            $0.append(NSAttributedString(string: "는 지금 "))
            $0.append(weatherInformation)
            $0.append(NSAttributedString(string: "\n"))
            
            if !supplies.string.isEmpty {
                $0.append(supplies)
                $0.append(NSAttributedString(string: " 챙겨보세요!"))
            }
        }
        
        return weatherResult
    }
    
    private func makeString<T: RawRepresentable>(
        _ array: [T?]
    ) -> NSMutableAttributedString where T.RawValue == String {
        
        let resultAttributedString = NSMutableAttributedString()
        let separator = NSAttributedString(string: HomeViewModel.seperator)
        
        for (index, element) in array.compactMap({ $0?.rawValue }).enumerated() {
            let fullText = element
            let firstSpaceIndex = fullText.firstIndex(of: " ") ?? fullText.endIndex
            let firstWord = String(fullText[..<firstSpaceIndex])
            let attributedText = fullText.customText(rangedText: firstWord)
            
            resultAttributedString.append(attributedText)
            
            if index < array.compactMap({ $0?.rawValue }).count - 1 {
                resultAttributedString.append(separator)
            }
        }
        return resultAttributedString
    }
    
    private func addMissionContent(
        _ missionID: Int,
        _ content: String,
        _ beforeState: ListItemState,
        _ state: ListItemState,
        _ isChecked: Bool
    ) {
        if !isExistMission(content: content) {
            self.missions.append((missionID, content, beforeState, state, isChecked))
        }
    }
    
    private func isExistMission(content: String) -> Bool {
        missions.contains(where: { mission in
            mission.content == content
        })
    }
}

extension HomeViewModel {
    
    var missionsCount: Int {
        missions.count
    }
    
    func getMissionTitle(at index: Int) -> String {
        missions[index].content
    }
    
    func getMissionState(at index: Int) -> ListItemState {
        missions[index].state
    }
    
    func getBeforeMissionState(at index: Int) -> ListItemState {
        missions[index].initState
    }
    
    func isTodayMission(at index: Int) -> Bool {
        missions[index].state == .today
    }
    
    func removeMission(at index: Int) {
        missions.remove(at: index)
    }
    
    func getMissionID(at index: Int) -> Int {
        missions[index].missionID
    }
    
    private func completeMission(at index: Int) {
        missions[index].state = .completed
        missions[index].isChecked = true
        let removed = missions.remove(at: index)
        missions.append(removed)
    }
}
