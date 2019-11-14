//
//  CoordinatorFactory.swift
//  movies
//
//  Created by Santiago B on 13/04/2019.
//  Copyright © 2019 zeta. All rights reserved.
//

protocol CoordinatorFactoryProtocol {
    func makeAuthCoordinatorBox(router: RouterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, dependenciesAssembler: DependenciesAssembler, viewControllerFactory: ViewControllerFactory) -> AuthCoordinator
    func makeMainCoordinatorBox(router: RouterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, dependenciesAssembler: DependenciesAssembler, viewControllerFactory: ViewControllerFactory) -> MainCoordinator
}

final class CoordinatorFactory: CoordinatorFactoryProtocol {
    
    // MARK: - CoordinatorFactoryProtocol
    
    func makeAuthCoordinatorBox(router: RouterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, dependenciesAssembler: DependenciesAssembler, viewControllerFactory: ViewControllerFactory) -> AuthCoordinator {
        let coordinator = AuthCoordinator(router: router, coordinatorFactory: coordinatorFactory, dependenciesAssembler: dependenciesAssembler, viewControllerFactory: viewControllerFactory)
        return coordinator
    }
    
    func makeMainCoordinatorBox(router: RouterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, dependenciesAssembler: DependenciesAssembler, viewControllerFactory: ViewControllerFactory) -> MainCoordinator {
        let coordinator = MainCoordinator(router: router, coordinatorFactory: coordinatorFactory, viewControllerFactory: viewControllerFactory, dependenciesAssembler: dependenciesAssembler)
        return coordinator
    }
}
