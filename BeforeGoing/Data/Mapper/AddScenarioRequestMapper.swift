//
//  AddScenarioRequestMapper.swift
//  BeforeGoing
//
//  Created by APPLE on 9/26/25.
//

struct AddScenarioRequestMapper: Mapper {
    
    typealias Input = (
        scenarioName: String,
        memo: String,
        basicMissions: [String],
        isNotificationActive: Bool,
        noticeMethodType: String?,
        daysOfWeekOrdinal: [Int]?,
        startHour: Int?,
        startMinute: Int?
    )
    
    typealias Output = AddScenarioRequestDTO
    
    func map(
        _ input: (
            scenarioName: String,
            memo: String,
            basicMissions: [String],
            isNotificationActive: Bool,
            noticeMethodType: String?,
            daysOfWeekOrdinal: [Int]?,
            startHour: Int?,
            startMinute: Int?
        )
    ) -> Output {
        if input.isNotificationActive {
            guard let notificationMethodType = input.noticeMethodType,
                  let daysOfWeekOrdinal = input.daysOfWeekOrdinal,
                  let startHour = input.startHour,
                  let startMinute = input.startMinute else {
                BeforeGoingLogger.error(BeforeGoingError.invalidParameter)
                return .withNotification(WithNotificationAddScenarioRequestDTO.stub())
            }
            
            return createWithNotificationAddScenarioRequestDTO(
                scenarioName: input.scenarioName,
                memo: input.memo,
                basicMissions: input.basicMissions,
                notificationMethodType: notificationMethodType,
                daysOfWeekOrdinal: daysOfWeekOrdinal,
                startHour: startHour,
                startMinute: startMinute
            )
        }
        return createWithoutNotificationAddScenarioRequestDTO(
            scenarioName: input.scenarioName,
            memo: input.memo,
            basicMissions: input.basicMissions
        )
    }
    
    private func createWithNotificationAddScenarioRequestDTO(
        scenarioName: String,
        memo: String,
        basicMissions: [String],
        notificationMethodType: String,
        daysOfWeekOrdinal: [Int],
        startHour: Int,
        startMinute: Int
    ) -> AddScenarioRequestDTO {
        
        return .withNotification(
            .init(
                scenarioName: scenarioName,
                memo: memo,
                basicMissions: basicMissions.map { BasicMissionContentDTO(content: $0)
                },
                notification: .init(
                    notificationType: NotificationType.time.rawValue,
                    notificationMethodType: notificationMethodType,
                    daysOfWeekOrdinal: daysOfWeekOrdinal
                ),
                notificationCondition: .init(
                    notificationType: NotificationType.time.rawValue,
                    startHour: startHour,
                    startMinute: startMinute
                )
            )
        )
    }
    
    private func createWithoutNotificationAddScenarioRequestDTO(
        scenarioName: String,
        memo: String,
        basicMissions: [String]
    ) -> AddScenarioRequestDTO {
        
        return .withoutNotification(
            .init(
                scenarioName: scenarioName,
                memo: memo,
                basicMissions: basicMissions.map { BasicMissionContentDTO(content: $0) },
                notification: .init(notificationType: NotificationType.time.rawValue)
            )
        )
    }
}
