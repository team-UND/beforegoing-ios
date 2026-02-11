//
//  ContextProvider.swift
//  BeforeGoing
//
//  Created by APPLE on 2/5/26.
//

import CoreData

enum ContextProvider {
    
    static func createMockContext() -> NSManagedObjectContext {
        let container = NSPersistentContainer(name: "BeforeGoingModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _, error in
            if let error = error { fatalError("Failed to load store: \(error)") }
        }
        return container.viewContext
    }
}
