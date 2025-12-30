//
//  HomeViewModel.swift
//  BeforeGoing
//
//  Created by APPLE on 9/23/25.
//

import CoreLocation
import Foundation
import UIKit

protocol HomeOutput {}

final class HomeViewModel: ViewModeling {
    
    private static let seperator = ", "
    private let todayMissionLimit = 20
    
    private let getMemberNameUseCase: GetMemberNameType
    private let weatherUseCase: FetchWeatherType
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
        getMemberNameUseCase: GetMemberNameType,
        weatherUseCase: FetchWeatherType,
        getMissionsUseCase: FetchMissionsType,
        checkMissionUseCase: CheckMissionType,
        addTodayMissionUseCase: AddTodayMissionType,
        deleteTodayMissionUseCase: DeleteTodayMissionType
    ) {
        self.getMemberNameUseCase = getMemberNameUseCase
        self.weatherUseCase = weatherUseCase
        self.getMissionsUseCase = getMissionsUseCase
        self.checkMissionUseCase = checkMissionUseCase
        self.addTodayMissionUseCase = addTodayMissionUseCase
        self.deleteTodayMissionUseCase = deleteTodayMissionUseCase
    }
    
    enum Input {
        case requestName
        case requestDate
        case requestWeather(
            date: Date,
            memberName: String,
            latitude: CLLocationDegrees,
            longitude: CLLocationDegrees
        )
        case scenarioDidTap(
            scenarioID: Int,
            date: String
        )
        case missionChecked(
            missionID: Int,
            date: String,
            willBeChecked: Bool
        )
        case addTodayMissionButtonDidTap(
            scenarioID: Int,
            date: String,
            content: String
        )
        case deleteTodayMissionButtonDidTap(missionID: Int)
    }
    
    typealias Output = HomeOutput
    
    struct MemberNameOutput: HomeOutput {
        let memberName: String
    }
    
    struct DateOutput: HomeOutput {
        let date: String
    }
    
    struct WeatherOutput: HomeOutput {
        let weatherResult: Result<NSMutableAttributedString, Error>
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
        case .requestName:
            let memberName = getMemberNameUseCase.execute()
            return MemberNameOutput(memberName: memberName)
            
        case .requestDate:
            let date = DateUtil.getCurrentDate(format: "yyyy년 MM월 dd일")
            return DateOutput(date: date)
            
        case .requestWeather(let date, let memberName, let latitude, let longitude) :
            let administrativeArea: NSMutableAttributedString
            
            do {
                administrativeArea = try await getAdministrativeArea(
                    latitude: latitude,
                    longitude: longitude
                )
            } catch (let error) {
                return WeatherOutput(weatherResult: .failure(error))
            }
            
            do {
                let result = try await requestWeatherResult(
                    date: date,
                    latitude: latitude,
                    longitude: longitude
                )
                
                let weatherResult = convertWeatherResult(
                    memberName: memberName,
                    date: date,
                    administrativeArea: administrativeArea,
                    weather: result
                )
                return WeatherOutput(weatherResult: .success(weatherResult))
                
            } catch (let error) {
                return WeatherOutput(weatherResult: .failure(error))
            }
            
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
                sortMissions()
                return MissionsOutput(missionsResult: .success(result))
            } catch {
                BeforeGoingLogger.error(error)
                return MissionsOutput(missionsResult: .failure(error))
            }
            
        case .missionChecked(let missionID, let date, let willBeChecked):
            do {
                try await checkMissionUseCase.execute(
                    missionID: missionID,
                    date: date,
                    isChecked: willBeChecked
                )
                if let index = missions.firstIndex(where: { $0.missionID == missionID }) {
                    willBeChecked ? completeMission(at: index) : cancelMission(at: index)
                }
            } catch {
                BeforeGoingLogger.error(error)
            }
            return EmptyOutput()
            
        case .addTodayMissionButtonDidTap(let scenarioID, let date, let content):
            if isLimitTodayMissions {
                return TodayMissionOutput(todayMissionResult: .failure(BeforeGoingError.missionLimitError))
            }
            
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
                sortMissions()
                
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
    
    func isExistMission(content: String) -> Bool {
        missions.contains(where: { mission in
            mission.content == content
        })
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
        date: Date,
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees
    ) async throws -> WeatherEntity? {
        let timezone = TimeZone.current.identifier
        let result = try await weatherUseCase.execute(
            date: date,
            timezone: timezone,
            location: CLLocation(latitude: latitude, longitude: longitude)
        )
        return result
    }
    
    private func convertWeatherResult(
        memberName: String,
        date: Date,
        administrativeArea: NSMutableAttributedString,
        weather: WeatherEntity?
    ) -> NSMutableAttributedString {
        
        var weatherResult = NSMutableAttributedString()
        
        guard let monthAndDay = DateUtil.toMonthAndDay(date: date) else {
            return weatherResult
        }
        
        guard let weather else {
            makeNoWeatherDataString(
                memberName: memberName,
                monthAndDay: monthAndDay,
                date: date,
                weatherResult: weatherResult
            )
            return weatherResult
        }
        
        makeWeatherDataString(
            weather: weather,
            weatherResult: weatherResult,
            administrativeArea: administrativeArea
        )
        
        addLineSpacing(weatherResult: weatherResult)
        
        return weatherResult
    }
    
    private func makeNoWeatherDataString(
        memberName: String,
        monthAndDay: String,
        date: Date,
        weatherResult: NSMutableAttributedString
    ) {
        let scenarioIntroduce = "\(memberName)님의 \(monthAndDay) 시나리오예요!".customText(
            rangedText: "\(memberName)",
            color: UIColor.blue700.cgColor
        )
        
        if date < DateUtil.getCurrentDate() {
            weatherResult.append(NSAttributedString(string: "지난 날짜의 기상 정보는 제공하지 않아요"))
        } else {
            weatherResult.append(NSAttributedString(string: "해당 날짜의 기상 정보는 확인하기 어려워요"))
        }
        weatherResult.append(NSAttributedString(string: "\n"))
        weatherResult.append(scenarioIntroduce)
    }
    
    private func makeWeatherDataString(
        weather: WeatherEntity,
        weatherResult: NSMutableAttributedString,
        administrativeArea: NSMutableAttributedString
    ) {
        let weatherInformation = makeWeatherString(weather)
        let supplies = makeSupplyString(weather)
        
        weatherResult.do {
            $0.append(administrativeArea)
            $0.append(NSAttributedString(string: "는 지금 "))
            $0.append(weatherInformation)
            
            if let supplies,
               !supplies.string.isEmpty {
                $0.append(NSAttributedString(string: "\n"))
                $0.append(supplies)
                $0.append(NSAttributedString(string: " 챙겨보세요!"))
            }
        }
    }
    
    private func addLineSpacing(weatherResult: NSMutableAttributedString) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4
        style.alignment = .center
        
        weatherResult.addAttribute(
            .paragraphStyle,
            value: style,
            range: NSRange(location: 0, length: weatherResult.length)
        )
    }
    
    private func makeWeatherString(_ weather: WeatherEntity) -> NSMutableAttributedString {
        let weatherDescription = weather.weatherCondition.description
        let uvDescription = weather.uvIndex.description
        let weatherString = "\(weatherDescription), 자외선 \(uvDescription)!"
        let customedWeatherString = weatherString.customText(rangedText: "\(weatherDescription), 자외선")
        
        return customedWeatherString
    }
    
    private func makeSupplyString(_ weather: WeatherEntity) -> NSMutableAttributedString? {
        let supplies = [
            weather.weatherCondition.supply,
            weather.uvIndex.supply
        ].compactMap { $0 }
        
        guard !supplies.isEmpty else {
            return nil
        }
        
        let supplyString = supplies.joined(separator: ", ")
        let customedSupplyString = supplyString.customText(
            rangedText: supplyString,
            color: UIColor.blue700.cgColor
        )
        return customedSupplyString
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
    
    private var isLimitTodayMissions: Bool {
        missions.filter({ $0.initState == .today }).count >= todayMissionLimit
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
        
        sortMissions()
    }
    
    private func cancelMission(at index: Int) {
        missions[index].state = missions[index].initState
        missions[index].isChecked = false
        let removed = missions.remove(at: index)
        missions.insert(removed, at: 0)
        
        sortMissions()
    }
    
    private func sortMissions() {
        missions.sort { mission1, mission2 in
            let isChecked1 = mission1.isChecked
            let isChecked2 = mission2.isChecked
            if isChecked1 != isChecked2 {
                return !isChecked1
            }
            
            let isBasicMission1 = mission1.initState == .normal
            let isBasicMission2 = mission2.initState == .normal
            if isBasicMission1 != isBasicMission2 {
                return !isBasicMission1
            }
            
            return mission1.missionID < mission2.missionID
        }
    }
}
