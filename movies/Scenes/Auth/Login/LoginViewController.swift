//
//  LoginViewController.swift
//  movies
//  movies
//
//  Created by Santiago B on 13/04/2019.

import UIKit

protocol LoginViewControllerProtocol: class {
    var onLogin: (() -> Void)? { get set }
    var onRegister: (() -> Void)? { get set }
    var onChangePassword: (() -> Void)? { get set }
}

class LoginViewController: UIViewController, LoginViewControllerProtocol {
    
    // MARK: - LoginViewControllerProtocol
    
    var onLogin: (() -> Void)?
    var onRegister: (() -> Void)?
    var onChangePassword: (() -> Void)?
    
    // MARK: - Vars & Lets
    
    var viewModel: LoginViewModelProtocol?
    
    // MARK: - Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func login() {
        self.onLogin?()
    }
    
    @IBAction func register() {
        self.onRegister?()
    }
    
    @IBAction func forgetPassword() {
        self.onChangePassword?()
    }
    
}
