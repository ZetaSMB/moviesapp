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
    var authServiceMocked: FakeRealmAuthService!
    
    override func setUp() {
        routerMock = RouterMockImp()
        authServiceMocked = FakeRealmAuthService()
        sut = ApplicationCoordinator(router: routerMock,
                                     coordinatorFactory: CoordinatorFactory(),
                                     dependenciesAssembler: FakeDependenciesAssembler(repository: TMDbRepository.shared, authServiceMocked))
    }

    override func tearDown() {
        sut = nil
    }

    func testStartAsLogoutUser() {
        sut.start()
        XCTAssertEqual(routerMock.navigationStack.count, 1, "Only 1 UIController")
        XCTAssert(routerMock.navigationStack.first is LoginViewController, "First must be login ViewController")
    }
    
    func testStartAsLoggedInUser() {
        authServiceMocked.registerUser(username: "user", password: "pass", completionHandler: { (_) in })
        authServiceMocked.login(username: "user", password: "pass", completionHandler: { (_) in })
        sut.start()
        XCTAssertEqual(routerMock.navigationStack.count, 1, "Only 1 UIController")
        XCTAssert(routerMock.navigationStack.first is UITabBarController, "First must be login UITabBarController")
    }
}
