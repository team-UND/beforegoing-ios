//
//  ContextProvider.swift
//  BeforeGoing
//
//  Created by APPLE on 2/5/26.
//

import CoreData

enum ContextProvider {
    
    static func makeMockContext() -> NSManagedObjectContext {
        // 앱과 동일한 모델 인스턴스를 재사용
        let container = NSPersistentContainer(
            name: "BeforeGoingModel",
            managedObjectModel: CoreDataStack.managedObjectModel
        )
        
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null/\(UUID().uuidString)")
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _, error in
            if let error { fatalError("Failed to load store: \(error)") }
        }
        
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return context
    }
}
