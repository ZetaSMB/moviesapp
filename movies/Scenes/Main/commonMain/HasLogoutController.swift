//
//  ExitableViewController.swift
//  movies
//
//  Created by Santiago Beltramone on 11/19/19.
//  Copyright © 2019 zeta. All rights reserved.
//

import Foundation

typealias OptionalAction = (() -> Void)?

protocol HasLogoutController {
    var onLogoutAction: OptionalAction { get set }
}
