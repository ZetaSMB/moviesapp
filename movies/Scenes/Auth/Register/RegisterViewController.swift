//
//  RegisterViewController.swift
//  movies
//
//  Created by Santiago B on 13/04/2019.
//  Copyright © 2019 zeta. All rights reserved.

import UIKit

protocol RegisterViewControllerProtocol: class {
    var onRegister: (() -> Void)? { get set }
    var onBack: (() -> Void)? { get set }
}

class RegisterViewController: UIViewController, RegisterViewControllerProtocol {
    
    // MARK: - RegisterViewControllerProtocol
    
    var onRegister: (() -> Void)?
    var onBack: (() -> Void)?
    
    // MARK: - Vars & Lets
    
    var viewModel: RegisterViewModelProtocol?
    
    // MARK: - Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func register() {
        self.onRegister?()
    }
    
    @IBAction func back() {
        self.onBack?()
    }
    
}
