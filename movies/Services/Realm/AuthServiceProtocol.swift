//
//  AuthProtocol.swift
//  movies
//
//  Created by Santiago Beltramone on 11/14/19.
//  Copyright © 2019 zeta. All rights reserved.
//

import Foundation
import RealmSwift

protocol AuthServiceProtocol {
    func isLoggedInUser() -> Bool
    func login(username: String, password: String, successHandler: @escaping UserCompletionBlock)
    func registerUser(username: String, password: String, successHandler: @escaping UserCompletionBlock)
    func logoutUser()
}
