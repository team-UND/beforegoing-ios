//
//  DIContainer+.swift
//  BeforeGoing
//
//  Created by APPLE on 9/14/25.
//

extension DIContainer {
    
    func injectDependency() {
        DataDependencyAssembler().assemble()
        DomainDependencyAssembler().assemble()
        PresentationDependencyAssembler().assemble()
    }
}
