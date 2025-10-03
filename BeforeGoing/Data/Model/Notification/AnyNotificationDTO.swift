//
//  AnyNotificationDTO.swift
//  BeforeGoing
//
//  Created by APPLE on 9/27/25.
//

struct AnyNotificationDTO: Decodable {
    let isActive: Bool
    let activeData: ActiveNotificationResponseDTO?
    let inactiveData: InactiveNotificationResponseDTO?
    
    enum CodingKeys: CodingKey {
        case isActive
        case activeData
        case inactiveData
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let isNotificationActive = try container.decode(Bool.self, forKey: .isActive)
        
        if isNotificationActive {
            self.isActive = true
            let active = try ActiveNotificationResponseDTO(from: decoder)
            self.activeData = active
            self.inactiveData = nil
            return
        }
        
        self.isActive = false
        let inactive = try InactiveNotificationResponseDTO(from: decoder)
        self.activeData = nil
        self.inactiveData = inactive
    }
}

struct ActiveNotificationResponseDTO: Decodable {
    let notificationId: Int
    var isActive: Bool = true
    let notificationType: String
    let notificationMethodType: String
    let daysOfWeekOrdinal: [Int]
}

struct InactiveNotificationResponseDTO: Decodable {
    let notificationId: Int
    var isActive: Bool = false
    let notificationType: String
}

extension AnyNotificationDTO {
    
    func toEntity() -> AnyNotificationEntity {
        if let activeData = activeData {
            return .init(active: activeData.toEntity())
        }
        if let inactiveData = inactiveData {
            return .init(inactive: inactiveData.toEntity())
        }
        fatalError("Neither activeData nor inactiveData is available")
    }
}

extension ActiveNotificationResponseDTO {
    
    func toEntity() -> ActiveNotificationEntity {
        guard let notificationMethodType = NoticeMethodType.findMethod(value: notificationMethodType) else {
            return .stub()
        }
        return .init(
            notificationID: notificationId,
            notificationType: notificationType,
            notificationMethodType: notificationMethodType,
            daysOfWeekOrdinal: daysOfWeekOrdinal
        )
    }
}

extension InactiveNotificationResponseDTO {
    
    func toEntity() -> InactiveNotificationEntity {
        return .init(
            notificationID: notificationId,
            notificationType: notificationType
        )
    }
}
