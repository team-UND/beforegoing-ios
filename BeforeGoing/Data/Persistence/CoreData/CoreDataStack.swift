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
    
    // 모델을 static으로 분리해서 외부에서 접근 가능하게
    static let managedObjectModel: NSManagedObjectModel = {
        let modelName = "BeforeGoingModel"
        let uniqueBundles: [Bundle] = Bundle.allBundles
            .compactMap { bundle -> (Bundle, URL)? in
                guard let url = bundle.url(forResource: modelName, withExtension: "mom") else {
                    return nil
                }
                return (bundle, url)
            }
            .reduce(into: [(Bundle, URL)]()) { result, pair in
                if !result.contains(where: { $0.1.path == pair.1.path }) {
                    result.append(pair)
                }
            }
            .map { $0.0 }
        
        guard let model = NSManagedObjectModel.mergedModel(from: uniqueBundles) else {
            fatalError("NSManagedObjectModel을 로드할 수 없습니다.")
        }
        return model
    }()
    
    // 기존 container도 동일한 모델 인스턴스 사용
    private let container: NSPersistentContainer = {
        let container = NSPersistentContainer(
            name: "BeforeGoingModel",
            managedObjectModel: CoreDataStack.managedObjectModel
        )
        container.loadPersistentStores { _, error in
            if let error { fatalError("Failed to load store: \(error)") }
        }
        return container
    }()
    
    var context: NSManagedObjectContext { container.viewContext }
}
