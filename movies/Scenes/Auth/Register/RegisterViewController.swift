//
//  RegisterViewController.swift
//  movies
//
//  Created by Santiago B on 13/04/2019.
//  Copyright © 2019 zeta. All rights reserved.

import UIKit
import RxSwift
import RxCocoa
import PKHUD

protocol RegisterViewControllerProtocol: class {
    var onRegister: (() -> Void)? { get set }
    var onBack: (() -> Void)? { get set }
}

class RegisterViewController: UIViewController, RegisterViewControllerProtocol {
    
    @IBOutlet weak var userTxtField: UITextField!
    @IBOutlet weak var passTxtField: UITextField!
    @IBOutlet weak var confirmPassTxtField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    private let disposeBag = DisposeBag()
    
    var onRegister: (() -> Void)?
    var onBack: (() -> Void)?
    
    // MARK: - Vars & Lets
    var viewModelFactory: (RegisterViewModelInputs) -> RegisterViewModelType = { _ in fatalError("Must provide factory function first.") }
    private var viewModel: RegisterViewModelType?
    
    // MARK: - Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vmInput = RegisterViewModelInputs(username: userTxtField.rx.text.orEmpty.asDriver(),
                                              password: passTxtField.rx.text.orEmpty.asDriver(),
                                              confirmPassword: confirmPassTxtField.rx.text.orEmpty.asDriver(),
                                              registerTrigger: registerBtn.rx.tap.asDriver())
        viewModel = viewModelFactory(vmInput)
        if let vm = viewModel {
            vm.outputs
                .isFetching
                .drive(onNext: { (isFetching) in
                    if isFetching {
                        HUD.show(HUDContentType.progress)
                    } else {
                        HUD.hide()
                    }
                })
                .disposed(by: disposeBag)
                        
            vm.outputs
                .usernameIsValid
                .drive(onNext: { [weak self] (valid) in
                    guard let self = self else { return }
                    self.userTxtField.layer.borderColor = valid ? UIColor.clear.cgColor : UIColor.red.cgColor
                })
                .disposed(by: disposeBag)
            
//            let borderPassController = BehaviorSubject<Bool>.init(value: true)
//            borderPassController.bind(to: vm.outputs.passwordIsValid.asObservable())
//            borderPassController
//                .observeOn(MainScheduler())
//                .do(onNext: { (valid) in
//                    self.passTxtField.layer.borderColor = valid ? UIColor.clear.cgColor : UIColor.red.cgColor
//                })
//                .asDriver(onErrorJustReturn: false)
            
            vm.outputs
                .passwordIsValid
                .drive(onNext: { [weak self] (valid) in
                    guard let self = self else { return }
                    self.passTxtField.layer.borderColor = valid ? UIColor.clear.cgColor : UIColor.red.cgColor
                })
                .disposed(by: disposeBag)

            vm.outputs
                .confirmPasswordIsValid
                .drive(onNext: { [weak self] (valid) in
                    guard let self = self else { return }
                    self.userTxtField.layer.borderColor = valid ? UIColor.clear.cgColor : UIColor.red.cgColor
                })
                .disposed(by: disposeBag)
            
            vm.outputs
            .confirmPasswordIsValid
            .drive(onNext: { [weak self] (valid) in
                guard let self = self else { return }
                self.userTxtField.layer.borderColor = valid ? UIColor.clear.cgColor : UIColor.red.cgColor
            })
            .disposed(by: disposeBag)

            
        }
        
    }
    
    // MARK: - Actions
    
    @IBAction func register() {
        self.onRegister?()
    }
    
    @IBAction func back() {
        self.onBack?()
    }
    
}
