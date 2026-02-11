//
//  CoreDataStack.swift
//  BeforeGoing
//
//  Created by APPLE on 2/3/26.
//

import CoreData

final class CoreDataStack {
    
    static let shared = CoreDataStack()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BeforeGoingModel")
        container.loadPersistentStores { _, error in }
        return container
    }()
    
    func newBackgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
}
