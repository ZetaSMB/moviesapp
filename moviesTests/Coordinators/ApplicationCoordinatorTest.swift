//
//  AppCoordinatorTest.swift
//  moviesTests
//
//  Created by Santiago Beltramone on 12/2/19.
//  Copyright © 2019 zeta. All rights reserved.
//

import XCTest
@testable import movies

class ApplicationCoordinatorTest: XCTestCase {
    var sut: ApplicationCoordinator!
    //mocked
    var routerMock: RouterMockImp!
    
    override func setUp() {
        routerMock = RouterMockImp()
        sut = ApplicationCoordinator(router: routerMock, coordinatorFactory: CoordinatorFactory(), dependenciesAssembler: CoreDependenciesAssembler())
    }

    override func tearDown() {
        sut = nil
    }

    func testStart() {
        sut.start()
        XCTAssertEqual(routerMock.navigationStack.count, 1, "Only 1 UIController")
        XCTAssert(routerMock.navigationStack.first is LoginViewController, "First must be login ViewController")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
