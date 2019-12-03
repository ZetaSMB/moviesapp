//
//  BaseAppCoordinatorTest.swift
//  moviesTests
//
//  Created by Santiago Beltramone on 12/2/19.
//  Copyright © 2019 zeta. All rights reserved.
//

import XCTest
@testable import movies

class BaseCoordinatorTest: XCTestCase {
    var sut: BaseCoordinator!
    override func setUp() {
        super.setUp()
        sut = BaseCoordinator()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testCoordinatorArrayInitializedOfEmptyArray() {
        XCTAssertTrue(sut.childCoordinators.isEmpty)
    }
    
    func testCoordinatorAddDependency() {
        sut.addDependency(sut)
        XCTAssertTrue(sut.childCoordinators.first is BaseCoordinator)
        XCTAssertTrue(sut.childCoordinators.count == 1)
        sut.addDependency(sut)
        XCTAssertTrue(sut.childCoordinators.count == 1, "Dependency should have been loaded once")
        
        let newCoordinator = BaseCoordinator()
        sut.addDependency(newCoordinator)
        XCTAssertTrue(sut.childCoordinators.count == 2)
    }
    
    func testCoordinatorRemoveDependency() {
        sut.addDependency(sut)
        XCTAssertTrue(sut.childCoordinators.first is BaseCoordinator)
        sut.removeDependency(sut)
        XCTAssertTrue(sut.childCoordinators.isEmpty)
        sut.removeDependency(sut)
        XCTAssertTrue(sut.childCoordinators.isEmpty, "Dependency should have been removed once")
    }
}
