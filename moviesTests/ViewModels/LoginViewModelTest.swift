//
//  LoginViewModelTest.swift
//  moviesTests
//
//  Created by Santiago Beltramone on 12/4/19.
//  Copyright © 2019 zeta. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
import RxCocoa
//import RxTest
//import RxBlocking
@testable import movies

class LoginViewModelTest: XCTestCase {

    var sut: LoginViewModel!
    //Dependencies
    var loginTrigger: BehaviorRelay<UserPassCredentials>!
    var subscription: Disposable!
    var authService: FakeRealmAuthService!
    let userPassPair = ("fakeUserName", "fakeCorrectPass")
    let disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        loginTrigger = BehaviorRelay<UserPassCredentials>(value: ("", ""))
        authService = FakeRealmAuthService(usersNamesPassDict: [userPassPair.0: userPassPair.1])
        sut = LoginViewModel(LoginViewModelInputs(loginTrigger: loginTrigger.asDriver()), authService: authService)
    }

    override func tearDown() {
        sut = nil
        loginTrigger = nil
        authService = nil
        super.tearDown()
    }

    func testSuccessfullyLogin() {
        let promise = expectation(description: "User did login successfully")
        loginTrigger.accept(userPassPair)
        sut.outputs
            .loginResult
            .drive(onNext: { (result) in
                switch result {
                case .success:
                    promise.fulfill()
                default:
                    XCTFail("login should not be failed")
                }
            }, onCompleted: {
                XCTFail("should not complete")
            }) {
                print("disposed")
        }.disposed(by: disposeBag)
        wait(for: [promise], timeout: 0.1)
    }
      
    func testFailureLogin() {
      let promise = expectation(description: "User did login successfully")
           loginTrigger.accept(("wrongUser", "wrongPass"))
           sut.outputs
               .loginResult
               .drive(onNext: { (result) in
                   switch result {
                   case .failure:
                       promise.fulfill()
                   default:
                       XCTFail("login should not be successfull")
                   }
               }, onCompleted: {
                XCTFail("should not complete")
               }) {
                   print("disposed")
           }.disposed(by: disposeBag)
           wait(for: [promise], timeout: 0.1)
    }

}
