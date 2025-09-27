//
//  AnyNotificationEntity.swift
//  BeforeGoing
//
//  Created by APPLE on 9/27/25.
//

struct AnyNotificationEntity {
    let isActive: Bool
    let activeData: ActiveNotificationEntity?
    let inactiveData: InactiveNotificationEntity?
    
    init(active: ActiveNotificationEntity) {
        self.isActive = true
        self.activeData = active
        self.inactiveData = nil
    }
    
    init(inactive: InactiveNotificationEntity) {
        self.isActive = false
        self.activeData = nil
        self.inactiveData = inactive
    }
}

struct ActiveNotificationEntity {
    let notificationID: Int
    var isActive: Bool = true
    let notificationType: String
    let notificationMethodType: String
    let daysOfWeekOrdinal: [Int]
}

struct InactiveNotificationEntity {
    let notificationID: Int
    var isActive: Bool = false
    let notificationType: String
}

extension AnyNotificationEntity {
    
    static func stub() -> Self {
        return .init(active: ActiveNotificationEntity.stub())
    }
}

extension ActiveNotificationEntity {
    
    static func stub() -> Self {
        return .init(
            notificationID: 1,
            notificationType: "TIME",
            notificationMethodType: "PUSH",
            daysOfWeekOrdinal: [0, 1, 2, 3, 4, 5, 6, 7]
        )
    }
}

extension InactiveNotificationEntity {
    
    static func stub() -> Self {
        return .init(
            notificationID: 1,
            notificationType: "TIME"
        )
    }
}
