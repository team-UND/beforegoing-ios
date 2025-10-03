//
//  UpdateScenarioRequestMapper.swift
//  BeforeGoing
//
//  Created by APPLE on 9/27/25.
//

struct UpdateScenarioRequestMapper: Mapper {
    
    typealias Input = (
        scenarioName: String,
        memo: String,
        missions: [(missionID: Int?, content: String)],
        isNotificationActive: Bool,
        noticeMethodType: String?,
        daysOfWeekOrdinal: [Int]?,
        startHour: Int?,
        startMinute: Int?
    )
    
    typealias Output = UpdateScenarioRequestDTO
    
    func map(
        _ input: (
            scenarioName: String,
            memo: String,
            missions: [(missionID: Int?, content: String)],
            isNotificationActive: Bool,
            noticeMethodType: String?,
            daysOfWeekOrdinal: [Int]?,
            startHour: Int?,
            startMinute: Int?
        )
    ) -> UpdateScenarioRequestDTO {
        if input.isNotificationActive {
            if let noticeMethodType = input.noticeMethodType,
               let daysOfWeekOrdinal = input.daysOfWeekOrdinal,
               let startHour = input.startHour,
               let startMinute = input.startMinute {
                return createWithNotificationUpdateScenarioRequestDTO(
                    input: input,
                    noticeMethodType: noticeMethodType,
                    daysOfWeekOrdinal: daysOfWeekOrdinal,
                    startHour: startHour,
                    startMinute: startMinute
                )
            }
        }
        return createWithoutNotificationUpdateScenarioRequestDTO(input: input)
    }
    
    private func createWithNotificationUpdateScenarioRequestDTO(
        input: Input,
        noticeMethodType: String,
        daysOfWeekOrdinal: [Int],
        startHour: Int,
        startMinute: Int
    ) -> UpdateScenarioRequestDTO {
        return .withNotification(
            WithNotificationUpdateScenarioRequestDTO(
                scenarioName: input.scenarioName,
                memo: input.memo,
                basicMissions:
                    input.missions.map {
                        MissionContentDTO(missionId: $0.missionID, content: $0.content)
                    },
                notification: ActiveNotificationDTO(
                    notificationType: NotificationType.time.rawValue,
                    notificationMethodType: noticeMethodType,
                    daysOfWeekOrdinal: daysOfWeekOrdinal
                ),
                notificationCondition: NotificationConditionDTO(
                    notificationType: NotificationType.time.rawValue,
                    startHour: startHour,
                    startMinute: startMinute
                )
            )
        )
    }
    
    private func createWithoutNotificationUpdateScenarioRequestDTO(input: Input) -> UpdateScenarioRequestDTO {
        return .withoutNotification(
            WithoutNotificationUpdateScenarioRequestDTO(
                scenarioName: input.scenarioName,
                memo: input.memo,
                basicMissions:
                    input.missions.map {
                        MissionContentDTO(missionId: $0.missionID, content: $0.content)
                    },
                notification: InactiveNotificationDTO(notificationType: NotificationType.time.rawValue)
            )
        )
    }
}
