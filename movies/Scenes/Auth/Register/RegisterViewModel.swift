//
//  RegisterViewModel.swift
//  movies
//
//  Created by Santiago B on 13/04/2019.
//  Copyright © 2019 zeta. All rights reserved.

import RxSwift
import RxCocoa

typealias RegisterResult = Result<(), UserPrintableError> //Either Success without value or error with message

struct RegisterViewModelInputs {
    let username: Driver<String>
    let password: Driver<String>
    let confirmPassword: Driver<String>
    let registerTrigger: Driver<()>
}

protocol RegisterViewModelOutputs {
    var isFetching: Driver<Bool> { get }
    var usernameIsValid: Driver<Bool> { get }
    var passwordIsValid: Driver<Bool> { get }
    var confirmPasswordIsValid: Driver<Bool> { get }
    var formEnteredIsValid: Driver<Bool> { get }
    var registerResult: Driver<RegisterResult> { get }
}

protocol RegisterViewModelType {
    init(_ inputs: RegisterViewModelInputs, authService: AuthServiceProtocol)
    var outputs: RegisterViewModelOutputs { get }
}

final class RegisterViewModel: RegisterViewModelType, RegisterViewModelOutputs {
    private let disposeBag = DisposeBag()
    private let authService: AuthServiceProtocol
    private var _isFetching = BehaviorRelay<Bool>(value: false)
    private var _registerResult: Driver<RegisterResult>?
    private var _inputs: RegisterViewModelInputs
    private let _defaultError: RegisterResult
    public private(set) var usernameIsValid: Driver<Bool>
    public private(set) var passwordIsValid: Driver<Bool>
    public private(set) var confirmPasswordIsValid: Driver<Bool>
    public private(set) var formEnteredIsValid: Driver<Bool>
    
    private enum UIMessages {
        static let errorTitle: String = "Oops"
        static let passwordDontMatch: String = "Passwords entered don't match"
        static let registerFailedMessage: String = "Has been an error when creating your account"
    }
    
    required init(_ inputs: RegisterViewModelInputs, authService: AuthServiceProtocol) {
        _inputs = inputs
        self.authService = authService
        
        usernameIsValid = inputs
            .username
            .map({ !$0.isEmpty && $0.count > 3 })
            .asDriver()
        
        passwordIsValid = inputs
            .password
            .map({ !$0.isEmpty && $0.count > 5 })
            .asDriver()
        
        let lengthConfirmPassword: Observable<Bool> = inputs
            .confirmPassword
            .map({ !$0.isEmpty && $0.count > 5 })
            .asObservable()
        
        let passwordMatch: Observable<Bool> = inputs
            .confirmPassword
            .withLatestFrom(inputs.password) { ($0, $1) }
            .map { $0.0 == $0.1 }
            .asObservable()
        
        confirmPasswordIsValid = Observable.combineLatest(lengthConfirmPassword, passwordMatch)
            .map({ $0 && $1 })
            .asDriver(onErrorJustReturn: false)
        
        formEnteredIsValid = Observable
            .combineLatest([usernameIsValid.asObservable(), passwordIsValid.asObservable(), confirmPasswordIsValid.asObservable()]) { $0.allSatisfy { $0 } }
            .asDriver(onErrorJustReturn: false)
        
        _defaultError = RegisterResult.failure(UserPrintableError(title: UIMessages.errorTitle, message: UIMessages.registerFailedMessage))
    }
    
    public var outputs: RegisterViewModelOutputs {
        return self
    }

    var isFetching: Driver<Bool> {
        return _isFetching.asDriver()
    }
    
    var registerResult: Driver<RegisterResult> {
        if _registerResult == nil {
            let latestUserPass: Observable<(String,String)> = Observable.combineLatest(_inputs.username.asObservable(), _inputs.password.asObservable())
            _registerResult = _inputs.registerTrigger.asObservable()
                .withLatestFrom(latestUserPass)
                .flatMap { (arg) -> Observable<RegisterResult> in
                    let (user, pass) = arg
                    return self.registerUser(with: user, pass: pass).asObservable()
                }
                .asDriver(onErrorJustReturn: _defaultError)
        }
        //swiftlint:disable force_unwrapping
        return _registerResult!
        //swiftlint:enable
    }
    
    private func registerUser(with username: String, pass: String) -> Observable<RegisterResult> {
        return Observable.create { observer in
            self._isFetching.accept(true)
            self.authService.registerUser(username: username, password: pass) { (result) in
                self._isFetching.accept(false)
                switch result {
                    case .success:
                    observer.onNext(.success(()))
                    case .failure: //todo: apply different messages to different errors
                    observer.onNext(.failure(UserPrintableError(title: UIMessages.errorTitle, message: UIMessages.registerFailedMessage)))
                }
            }
            return Disposables.create()
        }
    }
}
