//
//  RegisterViewModelTest.swift
//  moviesTests
//
//  Created by Santiago Beltramone on 12/5/19.
//  Copyright © 2019 zeta. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking

@testable import movies

class RegisterViewModelTest: XCTestCase {

    var sut: RegisterViewModel!
    //inputs
    var inputUsername: BehaviorRelay<String>!
    var inputPassword: BehaviorRelay<String>!
    var inputConfirmPassword: BehaviorRelay<String>!
    var inputRegisterTrigger: PublishSubject<()>!
    var viewModelInputs: RegisterViewModelInputs!
    var subscription: Disposable!
    var authService: FakeRealmAuthService!
    let userPassPair = ("fakeUserName", "fakeCorrectPass")
    let disposeBag = DisposeBag()
    var scheduler: TestScheduler!
    
    override func setUp() {
        super.setUp()
        authService = FakeRealmAuthService(usersNamesPassDict: [userPassPair.0: userPassPair.1])
        scheduler = TestScheduler(initialClock: 0)
        inputUsername = BehaviorRelay<String>(value: "")
        inputPassword = BehaviorRelay<String>(value: "")
        inputConfirmPassword = BehaviorRelay<String>(value: "")
        inputRegisterTrigger = PublishSubject<()>()
        let inputs = RegisterViewModelInputs(username: inputUsername.asDriver(onErrorJustReturn: ""),
                                             password: inputPassword.asDriver(),
                                             confirmPassword: inputConfirmPassword.asDriver(),
                                             registerTrigger: inputRegisterTrigger.asDriver(onErrorJustReturn: ()))
        sut = RegisterViewModel(inputs, authService: authService)
    }

    override func tearDown() {
        sut = nil
        inputUsername = nil
        inputPassword = nil
        inputConfirmPassword = nil
        inputRegisterTrigger = nil
        authService = nil
        scheduler = nil
        super.tearDown()
    }

    func testFormFieldsValidity() {
        let isUsernameInputValid = scheduler.createObserver(Bool.self)
        let isPasswordInputValid = scheduler.createObserver(Bool.self)
        let isConfirmPasswordInputValid = scheduler.createObserver(Bool.self)
        let isFormValid = scheduler.createObserver(Bool.self)
        
        sut.outputs
            .usernameIsValid
            .drive(isUsernameInputValid)
            .disposed(by: disposeBag)
        
        sut.outputs
            .passwordIsValid
            .drive(isPasswordInputValid)
            .disposed(by: disposeBag)
        
        sut.outputs
            .confirmPasswordIsValid
            .drive(isConfirmPasswordInputValid)
            .disposed(by: disposeBag)
        
        sut.outputs
            .formEnteredIsValid
            .drive(isFormValid)
            .disposed(by: disposeBag)

        //Username field
        //OBS: this is not really necessary, just to try the scheduler
        // (this way of testing is usefull for checking the complete events and reaction times)
        scheduler.createColdObservable([.next(10, "a"),
                                        .next(20, "ab"),
                                        .next(30, "abc"),
                                        .next(40, "abcd")])
                 .bind(to: inputUsername)
                 .disposed(by: disposeBag)

        scheduler.createColdObservable([.next(10, "short"),
                                        .next(20, "CorrectLenght")])
                 .bind(to: inputPassword)
                 .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(30, "short"),
                                        .next(40, "CorrectNotMatching"),
                                        .next(50, "CorrectLenght")])
                .bind(to: inputConfirmPassword)
                .disposed(by: disposeBag)
        
        scheduler.start()

        XCTAssertEqual(isUsernameInputValid.events, [
          .next(0, false),
          .next(10, false),
          .next(20, false),
          .next(30, false),
          .next(40, true)
        ])
        
        XCTAssertEqual(isPasswordInputValid.events, [
          .next(0, false),
          .next(10, false),
          .next(20, true)
        ])
        
        XCTAssertEqual(isConfirmPasswordInputValid.events, [
          .next(0, false),
          .next(30, false),
          .next(40, false),
          .next(50, true)
        ])
    }
    
    func testSuccessfullRegister() {
        let promise = expectation(description: "User did login successfully")
        inputUsername.accept("aNewUser")
        inputPassword.accept("aValidPassword")
        inputConfirmPassword.accept("aValidPassword")
        sut.outputs
            .registerResult
            .drive(onNext: { (result) in
                print(result)
                switch result {
                case .success:
                    promise.fulfill()
                default:
                    XCTFail("register should not be failed")
                }
            }, onCompleted: {
                XCTFail("should not complete")
            }) {
                print("disposed")
            }
            .disposed(by: disposeBag)        
        inputRegisterTrigger.on(.next(()))
        wait(for: [promise], timeout: 0.1)
    }
}
