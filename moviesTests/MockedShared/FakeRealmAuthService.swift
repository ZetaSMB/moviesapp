//
//  FakeRealmAuthService.swift
//  moviesTests
//
//  Created by Santiago Beltramone on 12/2/19.
//  Copyright © 2019 zeta. All rights reserved.
//

import Foundation
@testable import movies
import RealmSwift

final class FakeRealmAuthService: AuthServiceProtocol {
        
    var usersMap: [String: String]
    var loggedUserName: String?
        
    init(usersNamesPassDict dict: [String: String] = [:]) {
        usersMap = dict
    }
    
    func isLoggedInUser() -> Bool {
        return loggedUserName != nil
    }
    
    func login(username: String, password: String, completionHandler: @escaping AuthCompletionBlock) {
        if let keyForUser = usersMap[username], keyForUser == password {
            loggedUserName = username
            completionHandler(.success(()))
        } else {
            completionHandler(.failure(AuthError.userOrPasswordDoesNotExist))
        }
    }
    
    func registerUser(username: String, password: String, completionHandler: @escaping AuthCompletionBlock) {
        if let keyForUser = usersMap[username], keyForUser == password {
            completionHandler(.failure(AuthError.creatingUserAlreadyExist))
        } else {
            usersMap[username] = password
            completionHandler(.success(()))
        }
    }
    
    func logoutUser() {
        loggedUserName = nil
    }
}
