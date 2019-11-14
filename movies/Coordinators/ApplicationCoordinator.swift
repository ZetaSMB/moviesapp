//
//  AuthCoordinator.swift
//  movies
//
//  Created by Santiago Beltramone on 11/13/19.
//  Copyright © 2019 zeta. All rights reserved.
//

import Foundation

final class ApplicationCoordinator: BaseCoordinator {
    
    // MARK: - Vars & Lets
    
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let router: RouterProtocol
    private var launchInstructor = LaunchInstructor.configure()
    private let dependenciesAssembler: DependenciesAssembler
    
    // MARK: - Coordinator
    
    override func start(with option: DeepLinkOption?) {
        if option != nil {
            
        } else {
            switch launchInstructor {
            case .auth:
                runAuthFlow()
            case .main:
                runMainFlow()
            }
        }
    }
    
    // MARK: - Private methods
    
    private func runAuthFlow() {
        let coordinator = self.coordinatorFactory.makeAuthCoordinatorBox(router: self.router, coordinatorFactory: self.coordinatorFactory, dependenciesAssembler: self.dependenciesAssembler, viewControllerFactory: ViewControllerFactory())
        coordinator.finishFlow = { [unowned self, unowned coordinator] in
            self.removeDependency(coordinator)
            self.launchInstructor = LaunchInstructor.configure(isAutorized: true)
            self.start()
        }
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func runMainFlow() {
        let coordinator = self.coordinatorFactory.makeMainCoordinatorBox(router: self.router, coordinatorFactory: CoordinatorFactory(), dependenciesAssembler: self.dependenciesAssembler, viewControllerFactory: ViewControllerFactory())
        coordinator.finishFlow = { [unowned self, unowned coordinator] in
            self.removeDependency(coordinator)
            self.launchInstructor = LaunchInstructor.configure(isAutorized: false) //TODO: add session manager
            self.start()
        }
        addDependency(coordinator)
        coordinator.start()
    }
    
    // MARK: - Init
    
    init(router: Router, coordinatorFactory: CoordinatorFactory, dependenciesAssembler: DependenciesAssembler) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.dependenciesAssembler = dependenciesAssembler
    }
    
}
