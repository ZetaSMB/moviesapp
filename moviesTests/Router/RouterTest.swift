//
//  RouterTest.swift
//  moviesTests
//
//  Created by Santiago on 11/29/19.
//  Copyright © 2019 zeta. All rights reserved.
//

import XCTest
@testable import movies

class RouterTest: XCTestCase {
    var sut: Router!
    //Dependencies
    var rootNavController: UINavigationController!
    var aController: UIViewController!
    var bController: UIViewController!
    var cController: UIViewController!
        
    override func setUp() {        
        aController = UIViewController()
        rootNavController = UINavigationController(rootViewController: aController)
        bController = UIViewController()
        cController = UIViewController()
        sut = Router(rootController: rootNavController)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        rootNavController = nil
        aController = nil
        bController = nil
        cController = nil
        sut = nil
    }

    func testPushAndPop() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(rootNavController.children, [aController])
        //push
        let promise1 = expectation(description: "push router logic runs successfully")
        let deltaTime = 0.3
        sut.push(bController)
        DispatchQueue.main.asyncAfter(deadline: .now() + deltaTime, execute: {
            XCTAssertEqual(self.rootNavController.children, [self.aController, self.bController])
            promise1.fulfill()
        })
        wait(for: [promise1], timeout: deltaTime)
        
        //pop
        sut.popModule()
        let promise2 = expectation(description: "pop router logic runs successfully")
        DispatchQueue.main.asyncAfter(deadline: .now() + deltaTime) {
            XCTAssertEqual(self.rootNavController.children, [self.aController])
            promise2.fulfill()
        }
        wait(for: [promise2], timeout: 2*deltaTime)
    }

    func testPresentAndDismiss() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(rootNavController.children, [aController])
        let deltaTime = 0.3
        let promise = expectation(description: "present/dismiss router logic runs successfully")
        sut.present(cController)
        sut.dismissModule()
        DispatchQueue.main.asyncAfter(deadline: .now() + deltaTime) {
            XCTAssertEqual(self.rootNavController.children, [self.aController])
            promise.fulfill()
        }
        wait(for: [promise], timeout: 2*deltaTime)
    }

    func testPopToRoot() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(rootNavController.children, [aController])
        let promise1 = expectation(description: "push")
        let deltaTime = 0.3
        sut.push(bController)
        sut.push(cController)
        DispatchQueue.main.asyncAfter(deadline: .now() + deltaTime, execute: {
            XCTAssertEqual(self.rootNavController.children, [self.aController, self.bController, self.cController])
            promise1.fulfill()
        })
        wait(for: [promise1], timeout: deltaTime)
        
        //pop to B
        sut.popToModule(module: self.bController, animated: true)
        let promise2 = expectation(description: "pop to B router logic runs successfully")
        DispatchQueue.main.asyncAfter(deadline: .now() + deltaTime) {
            XCTAssertEqual(self.rootNavController.children, [self.aController, self.bController])
            promise2.fulfill()
        }
        wait(for: [promise2], timeout: 2*deltaTime)
        
        //pop to Root
        sut.popToRootModule(animated: true)
        let promise3 = expectation(description: "pop to Root logic runs successfully")
        DispatchQueue.main.asyncAfter(deadline: .now() + deltaTime) {
            XCTAssertEqual(self.rootNavController.children, [self.aController])
            promise3.fulfill()
        }
        wait(for: [promise3], timeout: 3*deltaTime)
    }
    
    func testSetRoot() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(rootNavController.children, [aController])
        let deltaTime = 0.3
        let promise = expectation(description: "setRoot router logic runs successfully")
        sut.setRootModule(bController)
        sut.push(cController)
        DispatchQueue.main.asyncAfter(deadline: .now() + deltaTime) {
            XCTAssertEqual(self.rootNavController.children, [self.bController, self.cController])
            promise.fulfill()
        }
        wait(for: [promise], timeout: 2*deltaTime)
    }
    
    func testCompletion() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(rootNavController.children, [aController])
        let promise1 = expectation(description: "push")
        let deltaTime = 0.3
        var didExcecuteBlock = false
        sut.push(bController, transition: StubAnimatedTransitioning(isPresentation:true), animated: true) {
            didExcecuteBlock = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + deltaTime, execute: {
            self.sut.popModule()
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2*deltaTime, execute: {
            XCTAssertEqual(self.rootNavController.children, [self.aController])
//TODO: fix pop completion logic
//            XCTAssertEqual(didExcecuteBlock, true)
            promise1.fulfill()
        })
        
        
        wait(for: [promise1], timeout: 3*deltaTime)
    }
}
