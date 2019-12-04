//
//  AuthProtocol.swift
//  movies
//
//  Created by Santiago Beltramone on 11/14/19.
//  Copyright © 2019 zeta. All rights reserved.
//

import Foundation
import RealmSwift

public enum AuthError: Error {
    case realmError(Error)
    case userOrPasswordDoesNotExist
    case creatingUserAlreadyExist
    case unkownError
}

public typealias AuthCompletionBlock = (Result<(), Error>) -> Void

protocol AuthServiceProtocol {
    func isLoggedInUser() -> Bool
    func login(username: String, password: String, completionHandler: @escaping AuthCompletionBlock)
    func registerUser(username: String, password: String, completionHandler: @escaping AuthCompletionBlock)
    func logoutUser()
}
