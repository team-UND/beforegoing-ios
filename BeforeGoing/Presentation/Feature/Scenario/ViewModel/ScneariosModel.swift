//
//  ScnearioModel.swift
//  BeforeGoing
//
//  Created by APPLE on 12/3/25.
//

final class ScenariosModel {
    var scenarios: [ScenarioModel] = []

    func append(_ newElement: ScenarioModel) {
        scenarios.append(newElement)
    }
    
    func removeAll() {
        scenarios.removeAll()
    }
    
    func updateOrder(at index: Int, _ newOrder: Int) {
        scenarios[index].scenarioOrder = newOrder
    }
    
    func sort() {
        scenarios.sort(by: { $0.scenarioOrder < $1.scenarioOrder })
    }
    
    func getNotificationInformation(section: Int) -> String? {
        let scenario = scenarios[section]
        
        guard let daysOfWeek = scenario.daysOfWeek,
              let startHour = scenario.startHour,
              let startMinute = scenario.startMinute,
              let notificationMethodType = scenario.notificationMethodType else {
            return nil
        }
        
        return makeNotificationInformation(
            daysOfWeek: daysOfWeek,
            startHour: startHour,
            startMinute: startMinute,
            notificationMethodType: notificationMethodType
        )
    }
    
    private func makeNotificationInformation(
        daysOfWeek: [Int],
        startHour: Int,
        startMinute: Int,
        notificationMethodType: String
    ) -> String {
        let daysString = makeDaysString(daysOfWeek: daysOfWeek)
        let timeString = makeTimeString(startHour: startHour, startMinute: startMinute)
        let methodString = makeNotificationMethodString(notificationMethodType: notificationMethodType)
        
        return "\(daysString) | \(timeString) | \(methodString)"
    }
    
    private func makeDaysString(daysOfWeek: [Int]) -> String {
        if daysOfWeek.count == DaysOfWeek.allCases.count {
            return "매일"
        }
        
        let daysString = daysOfWeek
            .compactMap { DaysOfWeek(rawValue: $0)?.string }
            .joined(separator: ", ")
        return daysString
    }
    
    private func makeTimeString(startHour: Int, startMinute: Int) -> String {
        let timePeriod = makeTimePeriodString(startHour: startHour)
        let hour = makeHourString(startHour: startHour)
        let minute = makeMinuteString(startMinute: startMinute)
        
        return "\(timePeriod) \(hour):\(minute)"
    }
    
    private func makeNotificationMethodString(notificationMethodType: String) -> String {
        guard let methodString = NoticeMethodType.convertMethodName(string: notificationMethodType) else {
            return ""
        }
        return methodString
    }
    
    private func makeTimePeriodString(startHour: Int) -> String {
        var timePeriod = ""
        
        switch startHour {
        case 1...12:
            timePeriod = "오전"
        case 13...23:
            timePeriod = "오후"
        default:
            break
        }
        
        return timePeriod
    }
    
    private func makeHourString(startHour: Int) -> String {
        String(format: "%02d", (startHour < 13) ? startHour : startHour - 12)
    }
    
    private func makeMinuteString(startMinute: Int) -> String {
        String(format: "%02d", startMinute)
    }
}

struct ScenarioModel {
    let scenarioID: Int
    var scenarioName: String
    var scenarioOrder: Int
    var notificationMethodType: String?
    var daysOfWeek: [Int]?
    var startHour: Int?
    var startMinute: Int?
}
