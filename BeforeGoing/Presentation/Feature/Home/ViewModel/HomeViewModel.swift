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
    
    private var missions: [(missionID: Int, content: String, state: ListItemState)] = []
    
    init(
        weatherUseCase: RequestWeatherType,
        getMissionsUseCase: FetchMissionsType,
        checkMissionUseCase: CheckMissionType
    ) {
        self.weatherUseCase = weatherUseCase
        self.getMissionsUseCase = getMissionsUseCase
        self.checkMissionUseCase = checkMissionUseCase
    }
    
    enum Input {
        case requestDate
        case requestWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
        case scenarioDidTap(scenarioID: Int, date: String)
        case missionChecked(missionID: Int, date: String)
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
                result.todayMissions.forEach { addMissionContent($0.missionId, $0.content, .today) }
                result.basicMissions.forEach { addMissionContent($0.missionId, $0.content, .normal) }
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
            } catch {
                BeforeGoingLogger.error(error)
            }
            return EmptyOutput()
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
    
    private func addMissionContent(_ missionID: Int, _ content: String, _ state: ListItemState) {
        if !isExistMission(content: content) {
            self.missions.append((missionID, content, state))
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
    
//    func addTodayMission(content: String) {
//        missions.insert((content, .today), at: 0)
//    }
    
    func getMissionTitle(at index: Int) -> String {
        missions[index].content
    }
    
    func getMissionState(at index: Int) -> ListItemState {
        missions[index].state
    }
    
    func completeMission(at index: Int) {
        missions[index].state = .completed
        let removed = missions.remove(at: index)
        missions.append(removed)
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
}
