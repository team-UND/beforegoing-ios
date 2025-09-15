//
//  DIContainer+.swift
//  BeforeGoing
//
//  Created by APPLE on 9/14/25.
//

extension DIContainer {
    
    func injectDependency() {
        let dataDependencyAssembler = DataDependencyAssembler()
        let domainDependencyAssembler = DomainDependencyAssembler(preAssembler: dataDependencyAssembler)
        let presentationDependencyAssembler = PresentationDependencyAssembler(
            preAssembler: domainDependencyAssembler
        )
        presentationDependencyAssembler.assemble()
    }
}
