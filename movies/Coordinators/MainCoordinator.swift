//
//  FirstCoordinator.swift
//  CoordinatorTransitons
//
//  Created by Pavle Pesic on 5/18/18.
//  Copyright © 2018 Pavle Pesic. All rights reserved.
//
import UIKit

final class MainCoordinator: BaseCoordinator, CoordinatorFinishOutput {

    // MARK: - CoordinatorFinishOutput
    
    var finishFlow: (() -> Void)?
    
    // MARK: - Vars & Lets
    
    private let router: RouterProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let viewControllerFactory: ViewControllerFactory
    private let dependenciesAssembler: DependenciesAssembler
    
    // MARK: - Coordinator
    
    override func start() {
        let mainTabBar = self.viewControllerFactory.instantiateMainTabBarViewController(dependenciesAssembler)
        applyOnLogoutToChildren(viewController: mainTabBar, action: finishFlow)
        //TODO: each tabbar item nav controller should have an own coordinator
        self.router.setRootModule(mainTabBar, hideBar: true)
    }
    
    // MARK: - Init
         
    init(router: RouterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory, dependenciesAssembler: DependenciesAssembler) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.viewControllerFactory = viewControllerFactory
        self.dependenciesAssembler = dependenciesAssembler
    }

    // MARK: - Private methods
    
    private func applyOnLogoutToChildren(viewController: UIViewController, action: OptionalAction ) {
        for childController in viewController.children {
            switch childController {
            case is UINavigationController:
                applyOnLogoutToChildren(viewController: childController, action: action)
            case is HasLogoutController:
                if var child = childController as? HasLogoutController {                    
                    child.onLogoutAction = action
                }
            default:
                break
            }
        }
    }
}
