//
//  LoginViewModel.swift
//  movies
//
//  Created by Santiago B on 13/04/2019.
//  Copyright © 2019 zeta. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

typealias UserPassCredentials = (String, String)
typealias LoginResult = Result<(), UserPrintableError> //Either Success without value or error with message

struct LoginViewModelInputs {
    let loginTrigger: Driver<UserPassCredentials>
}

protocol LoginViewModelOutputs {
    var loginResult: Driver<LoginResult?> { get }
    var isFetching: Driver<Bool> { get }
}

protocol LoginViewModelType {
    init(_ inputs: LoginViewModelInputs, authService: AuthServiceProtocol)
    var outputs: LoginViewModelOutputs { get }
}

final class LoginViewModel: LoginViewModelType, LoginViewModelOutputs {
    private let disposeBag = DisposeBag()
    private var _loginResult = BehaviorRelay<LoginResult?>(value: nil)
    private var _isFetching = BehaviorRelay<Bool>(value: false)
    
    private enum UIMessages {
        static let userNameEmpty: String = "Please provide a valid username"
        static let passwordEmpty: String = "Please provide a valid password"
        static let loginFailedTitle: String = "Oops"
        static let loginFailedMessage: String = "Username or password invalid"
    }
    
    required init(_ inputs: LoginViewModelInputs, authService: AuthServiceProtocol) {
        inputs
            .loginTrigger
            .drive(onNext: { [weak self] (user, pass) in
                guard let self = self else { return }
                guard !user.isEmpty else {
                    self._loginResult.accept(.failure(UserPrintableError(title: UIMessages.loginFailedTitle, message: UIMessages.userNameEmpty)))
                    return
                }
                guard !pass.isEmpty else {
                    self._loginResult.accept(.failure(UserPrintableError(title: UIMessages.loginFailedTitle, message: UIMessages.passwordEmpty)))
                    return
                }
                
                self._isFetching.accept(true)
                authService.login(username: user, password: pass) { (_, err) in
                    self._isFetching.accept(false)
                    if let _ = err {
                        self._loginResult.accept(.failure(UserPrintableError(title: UIMessages.loginFailedTitle, message: UIMessages.loginFailedMessage)))
                    } else {
                        self._loginResult.accept(.success(()))
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    public var outputs: LoginViewModelOutputs {
        return self
    }

    var isFetching: Driver<Bool> {
        return _isFetching.asDriver()
    }
    
    var loginResult: Driver<LoginResult?> {
        return _loginResult.asDriver()
    }
}
