//
//  RouterMock.swift
//  moviesTests
//
//  Created by Santiago Beltramone on 12/2/19.
//  Copyright © 2019 zeta. All rights reserved.
//

import Foundation
import UIKit
@testable import movies

protocol RouterMock: RouterProtocol {
    var navigationStack: [UIViewController] { get }
    var presented: UIViewController? { get }
}

final class RouterMockImp: RouterMock {
    // in test cases router store the rootController referense
    private(set) var navigationStack: [UIViewController] = []
    private(set) var presented: UIViewController?
    private var completions: [UIViewController : () -> Void] = [:]
    
    func toPresent() -> UIViewController? {
        return nil
    }
    
    //all of the actions without animation
    func present(_ module: Presentable?) {
        present(module, animated: false)
    }
    func present(_ module: Presentable?, animated: Bool) {
        guard let controller = module?.toPresent() else { return }
        presented = controller
    }
    
    func push(_ module: Presentable?) {
        push(module, animated: false)
    }
    
    func push(_ module: Presentable?, animated: Bool) {
        push(module, animated: animated, completion: nil)
    }

    func push(_ module: Presentable?, hideBottomBar: Bool) {
        guard
            let controller = module?.toPresent(),
            (controller is UINavigationController == false)
            else { assertionFailure("Deprecated push UINavigationController."); return }

        controller.hidesBottomBarWhenPushed = hideBottomBar

        push(module, animated: false)
    }

    func push(_ module: Presentable?, animated: Bool, hideBottomBar: Bool, completion: (() -> Void)?) {

        guard
            let controller = module?.toPresent(),
            (controller is UINavigationController == false)
            else { assertionFailure("Deprecated push UINavigationController."); return }

        controller.hidesBottomBarWhenPushed = hideBottomBar
        navigationStack.append(controller)
    }
    
    func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?) {
        guard
            let controller = module?.toPresent(),
            (controller is UINavigationController == false)
            else { assertionFailure("Deprecated push UINavigationController."); return }
        navigationStack.append(controller)
    }
    
    func push(_ module: Presentable?, transition: UIViewControllerAnimatedTransitioning?) {
        push(module)
    }
    
    func push(_ module: Presentable?, transition: UIViewControllerAnimatedTransitioning?, animated: Bool) {
        push(module, animated: animated)
    }
    
    func push(_ module: Presentable?, transition: UIViewControllerAnimatedTransitioning?, animated: Bool, completion: (() -> Void)?) {
        push(module, animated: animated, completion: completion)
    }
    
    
    func popModule() {
        popModule(animated: false)
    }
    
    func popModule(animated: Bool) {
        let controller = navigationStack.removeLast()
        runCompletion(for: controller)
    }
    
    
    func popModule(transition: UIViewControllerAnimatedTransitioning?) {
        popModule(animated: false)
    }
    
    func popModule(transition: UIViewControllerAnimatedTransitioning?, animated: Bool) {
        popModule(animated: animated)
    }
    
    func popToModule(module: Presentable?, animated: Bool) {
        while let vc = navigationStack.last, vc == module as? UIViewController {
            popModule()
        }        
    }
    
    func dismissModule() {
        dismissModule(animated: false, completion: nil)
    }
    
    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        presented = nil
    }
    
    func setRootModule(_ module: Presentable?) {
        guard let controller = module?.toPresent() else { return }
        navigationStack.append(controller)
    }
    
    func setRootModule(_ module: Presentable?, hideBar: Bool) {
        navigationStack.removeAll()
        push(module)
    }

    func popToRootModule(animated: Bool) {
        guard let first = navigationStack.first else { return }
        
        navigationStack.forEach { controller in
            runCompletion(for: controller)
        }
        navigationStack = [first]
    }
    
    private func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
}
