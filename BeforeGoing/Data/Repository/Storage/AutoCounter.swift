//
//  AutoCounter.swift
//  BeforeGoing
//
//  Created by APPLE on 2/16/26.
//

import CoreData

enum AutoCounter {
    
    static func getNextID<T: NSManagedObject>(
        for entityType: T.Type,
        in context: NSManagedObjectContext
    ) -> Int64 {
        let entityName = String(describing: entityType)
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        request.fetchLimit = 1
        
        let lastID = getID(context: context, request: request) as? Int64 ?? 0
        return lastID + 1
    }
    
    private static func getID(
        context: NSManagedObjectContext,
        request: NSFetchRequest<NSManagedObject>
    ) -> Any? {
        try? context.fetch(request).first?.value(forKey: "id")
    }
}
