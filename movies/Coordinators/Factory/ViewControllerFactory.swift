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
        loginVC.viewModel = LoginViewModel()
        return loginVC
    }
    
    func instantiateRegisterViewController(_ dependenciesAssembler: DependenciesAssembler) -> RegisterViewController {
        let regVC: RegisterViewController = UIStoryboard.auth.instantiateVC()
        regVC.viewModel = RegisterViewModel()
        return regVC
    }
    
    func instantiateMainTabBarViewController(_ dependenciesAssembler: DependenciesAssembler) -> UITabBarController {
        let mainTabBar: UITabBarController = UIStoryboard.main.instantiateVC()
        return mainTabBar
    }
    
}
