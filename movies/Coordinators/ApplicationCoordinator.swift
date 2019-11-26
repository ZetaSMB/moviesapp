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
    private let dependenciesAssembler: DependenciesAssembler
    private let authService: AuthServiceProtocol
    
    private var isLoggedInUser: Bool {
        return authService.isLoggedInUser()
    }
    
    private var launchInstructor: LaunchInstructor {
        return LaunchInstructor.configure(isAutorized: isLoggedInUser)
    }
    
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
            self.start()
        }
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func runMainFlow() {
        let coordinator = self.coordinatorFactory.makeMainCoordinatorBox(router: self.router, coordinatorFactory: CoordinatorFactory(), dependenciesAssembler: self.dependenciesAssembler, viewControllerFactory: ViewControllerFactory())
        coordinator.finishFlow = { [unowned self, unowned coordinator] in
            self.removeDependency(coordinator)
            self.authService.logoutUser()
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
        self.authService = dependenciesAssembler.resolveAuthService()
    }
    
}
