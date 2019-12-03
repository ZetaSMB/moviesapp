//
//  RouterMockTest.swift
//  moviesTests
//
//  Created by Santiago Beltramone on 12/2/19.
//  Copyright © 2019 zeta. All rights reserved.
//

import XCTest
import Foundation
import UIKit
@testable import movies

class RouterMockTest: XCTestCase {
    
    private var router: RouterMock!
    
    class MockFirstViewController: UIViewController {}
    class MockSecondViewController: UIViewController {}
    class MockThirdViewController: UIViewController {}
    
    private var firstController: MockFirstViewController!
    private var secondController: MockSecondViewController!
    private var thirdController: MockThirdViewController!
    
    
    override func setUp() {
        super.setUp()
        router = RouterMockImp()
        firstController = MockFirstViewController()
        secondController = MockSecondViewController()
        thirdController = MockThirdViewController()
    }
    
    override func tearDown() {
        super.tearDown()
        router = nil
        firstController = nil
        secondController = nil
        thirdController = nil
    }
    
    func testRouterSetRootModule() {
        router.setRootModule(firstController)
        XCTAssertTrue(router.navigationStack.first is MockFirstViewController)
    }
    
    func testRouterPushViewModule() {
        router.setRootModule(firstController)
        XCTAssertTrue(router.navigationStack.last is MockFirstViewController)
        router.push(secondController)
        XCTAssertTrue(router.navigationStack.last is MockSecondViewController)
    }
    
    func testRouterPopViewModule() {
        router.setRootModule(firstController)
        XCTAssertTrue(router.navigationStack.last is MockFirstViewController)
        router.push(secondController)
        XCTAssertTrue(router.navigationStack.last is MockSecondViewController)
        router.popModule()
        XCTAssertTrue(router.navigationStack.last is MockFirstViewController)
    }
    
    func testRouterPopToRootViewModule() {
        router.setRootModule(firstController)
        XCTAssertTrue(router.navigationStack.last is MockFirstViewController)
        router.push(secondController)
        XCTAssertTrue(router.navigationStack.last is MockSecondViewController)
        router.push(thirdController)
        XCTAssertTrue(router.navigationStack.last is MockThirdViewController)
        router.popToRootModule(animated: false)
        XCTAssertTrue(router.navigationStack.last is MockFirstViewController)
    }
    
    func testPresentViewModule() {
        router.present(secondController)
        XCTAssertTrue(router.presented is MockSecondViewController)
    }
    
    func testDismissViewModule() {
        router.present(secondController)
        XCTAssertTrue(router.presented is MockSecondViewController)
        router.dismissModule()
        XCTAssertTrue(router.presented == nil)
    }
}
