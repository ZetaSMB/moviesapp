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
    @IBOutlet weak var backBtn: UIButton!
    
    private let disposeBag = DisposeBag()
    
    var onRegister: (() -> Void)?
    var onBack: (() -> Void)?
    
    // MARK: - Vars & Lets
    var viewModelFactory: (RegisterViewModelInputs) -> RegisterViewModelType = { _ in fatalError("Must provide factory function first.") }
    private var viewModel: RegisterViewModelType?
    
    private struct UIColors {
        static let clearBorderColor = UIColor.clear.cgColor
        static let redBorderColor = UIColor.red.cgColor
    }
    
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
                    self.userTxtField.layer.borderColor = valid ? UIColors.clearBorderColor : UIColors.redBorderColor
                })
                .disposed(by: disposeBag)
            
            vm.outputs
               .formEnteredIsValid
               .asObservable()
               .bind(to: registerBtn.rx.isEnabled)
               .disposed(by: disposeBag)

           applyBorderCorrectnessStyleValidation(on: userTxtField, validitySignal: vm.outputs.usernameIsValid.asObservable())
           applyBorderCorrectnessStyleValidation(on: passTxtField, validitySignal: vm.outputs.passwordIsValid.asObservable())
           applyBorderCorrectnessStyleValidation(on: confirmPassTxtField, validitySignal: vm.outputs.confirmPasswordIsValid.asObservable())
           
           vm.outputs
               .registerResult
               .drive(onNext: { [weak self] (result) in
                  guard let self = self else { return }
                   switch result {
                   case .success:
                       self.onRegister?()
                   case .failure(let err):
                       HUD.flash(.labeledError(title: err.title, subtitle: err.message), delay: 1.5, completion: nil)
                   }
               })
               .disposed(by: disposeBag)
        }
        
        backBtn.rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.onBack?()
            })
            .disposed(by: disposeBag)
    }
    
    private func applyBorderCorrectnessStyleValidation(on txtField: UITextField, validitySignal: Observable<Bool>) {
        let hasEditedPassword = txtField.rx
            .controlEvent([.editingDidBegin])
            .map({ return true })
            .asObservable()
        
        let borderPassController = BehaviorSubject<CGColor>.init(value: UIColors.clearBorderColor)
        validitySignal.asObservable()
            .skipUntil(hasEditedPassword)
            .map({
                $0 ?  UIColors.clearBorderColor :  UIColors.redBorderColor
            })
            .bind(to: borderPassController)
            .disposed(by: disposeBag)
        
        borderPassController
            .observeOn(MainScheduler())
            .asDriver(onErrorJustReturn: UIColors.clearBorderColor)
            .drive(onNext: { color in
                txtField.layer.borderColor = color
            })
            .disposed(by: disposeBag)
    }
}
