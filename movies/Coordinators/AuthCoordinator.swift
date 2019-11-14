//
//  AuthCoordinator.swift
//  movies
//
//  Created by Santiago Beltramone on 11/13/19.
//  Copyright © 2019 zeta. All rights reserved.
//

import Foundation
import UIKit

final class AuthCoordinator: BaseCoordinator, CoordinatorFinishOutput {
    
    // MARK: - CoordinatorFinishOutput
    
    var finishFlow: (() -> Void)?
    
    // MARK: - Vars & Lets
    
    private let router: RouterProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let viewControllerFactory: ViewControllerFactory
    private let dependenciesAssembler: DependenciesAssembler
    
    // MARK: - Private methods
    
    private func showLoginViewController() {
        let loginVC = viewControllerFactory.instantiateLoginViewController(dependenciesAssembler)
        loginVC.onLogin = { [unowned self] in
            self.finishFlow?()
        }
        loginVC.onRegister = { [unowned self] in
            self.showRegisterViewController()
        }
        router.setRootModule(loginVC, hideBar: true)
    }
    
    private func showRegisterViewController() {
        let registerVC: RegisterViewController = viewControllerFactory.instantiateRegisterViewController(dependenciesAssembler)
        registerVC.onBack = { [unowned self] in
            self.router.popModule()
        }
        registerVC.onRegister = { [unowned self] in
            self.router.popModule()
        }
        router.push(registerVC)
    }
    
    // MARK: - Coordinator
    
    override func start() {
        showLoginViewController()
    }
    
    // MARK: - Init
    
    init(router: RouterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, dependenciesAssembler: DependenciesAssembler, viewControllerFactory: ViewControllerFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.dependenciesAssembler = dependenciesAssembler
        self.viewControllerFactory = viewControllerFactory
    }
    
}
