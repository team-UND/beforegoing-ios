//
//  Terms+CoreDataProperties.swift
//  BeforeGoing
//
//  Created by APPLE on 2/2/26.
//
//

import Foundation
import CoreData

extension Terms {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Terms> {
        return NSFetchRequest<Terms>(entityName: "Terms")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var memberId: NSDecimalNumber?
    @NSManaged public var termsOfServiceAgreed: Bool
    @NSManaged public var privacyPolicyAgreed: Bool
    @NSManaged public var isOverFourteen: Bool
    @NSManaged public var eventPushAgreed: Bool
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?

}

extension Terms : Identifiable {

}
