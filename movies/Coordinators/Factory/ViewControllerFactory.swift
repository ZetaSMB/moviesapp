//
//  ViewControllerFactory.swift
//  movies
//
//  Created by Santiago B on 13/04/2019.
//  Copyright © 2019 zeta. All rights reserved.
//

import UIKit

class ViewControllerFactory {
    
    func instantiateLoginViewController(_ dependenciesAssembler: DependenciesAssembler) -> LoginViewController {
        let loginVC: LoginViewController = UIStoryboard.auth.instantiateVC()
        loginVC.viewModelFactory = { (loginViewModelInputs) in
            return LoginViewModel(loginViewModelInputs, authService: dependenciesAssembler.resolveAuthService())
        }
        return loginVC
    }
    
    func instantiateRegisterViewController(_ dependenciesAssembler: DependenciesAssembler) -> RegisterViewController {
        let regVC: RegisterViewController = UIStoryboard.auth.instantiateVC()
        regVC.viewModelFactory = { (regViewModelInputs) in
            return RegisterViewModel(regViewModelInputs, authService: dependenciesAssembler.resolveAuthService())
        }
        return regVC
    }
    
    func instantiateMainTabBarViewController(_ dependenciesAssembler: DependenciesAssembler) -> UITabBarController {
        let mainTabBar: UITabBarController = UIStoryboard.main.instantiateVC()
        return mainTabBar
    }
    
}