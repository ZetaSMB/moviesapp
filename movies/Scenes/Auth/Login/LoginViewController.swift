//
//  LoginViewController.swift
//  movies
//  movies
//
//  Created by Santiago B on 13/04/2019.

import UIKit
import PKHUD
import RxSwift
import RxCocoa

protocol LoginViewControllerProtocol: class {
    var onLogin: (() -> Void)? { get set }
    var onRegister: (() -> Void)? { get set }
}

class LoginViewController: UIViewController, LoginViewControllerProtocol {
    
    @IBOutlet weak var userTxtField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var passTxtField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    private let disposeBag = DisposeBag()

    // MARK: - LoginViewControllerProtocol
    var onLogin: (() -> Void)?
    var onRegister: (() -> Void)?
    
    // MARK: - Vars & Lets
    var viewModelFactory: (LoginViewModelInputs) -> LoginViewModelType = { _ in fatalError("Must provide factory function first.") }
    private var viewModel: LoginViewModelType?
    // MARK: - Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerBtn.rx
            .tap
            .bind(onNext: self.onRegister ?? {})
            .disposed(by: disposeBag)
        
        let onLoginTaped = loginBtn.rx
            .tap.map {
                return (self.userTxtField.text ?? "", self.passTxtField.text ?? "")
            }
            .asDriver(onErrorJustReturn: ("", ""))
        
        viewModel = viewModelFactory(LoginViewModelInputs(loginTrigger: onLoginTaped))
        guard let viewModel = viewModel else { return }
        viewModel
            .outputs
            .isFetching
            .drive(onNext: { (isFetching) in
                if isFetching {
                    HUD.show(HUDContentType.progress)
                } else {
                    HUD.hide()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel
            .outputs
            .loginResult
            .drive(onNext: { [weak self] (loginResult) in
                guard
                    let self = self,
                    let result = loginResult
                else { return }
                
                switch result {
                case .success:
                    if let onLogin = self.onLogin {
                        onLogin()
                    }
                case .failure(let err):
                    HUD.flash(.labeledError(title: err.title, subtitle: err.message), delay: 1.5, completion: nil)
                }
            })
            .disposed(by: disposeBag)
    }
    
}
