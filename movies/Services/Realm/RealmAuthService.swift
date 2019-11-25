//
//  RealmAuthService.swift
//  movies
//
//  Created by Santiago Beltramone on 11/14/19.
//  Copyright © 2019 zeta. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmAuthService: AuthServiceProtocol {
    
    func isLoggedInUser() -> Bool {
        return SyncUser.current != nil
    }
    
    func login(username: String, password: String, successHandler: @escaping UserCompletionBlock) {
        let creds = SyncCredentials.usernamePassword(username: username, password: password, register: false)
        SyncUser.logIn(with: creds, server: RealmConstants.AUTH_URL, onCompletion: successHandler)
    }
    
    func registerUser(username: String, password: String, successHandler: @escaping UserCompletionBlock) {
        let creds = SyncCredentials.usernamePassword(username: username, password: password, register: true)
        SyncUser.logIn(with: creds, server: RealmConstants.AUTH_URL, onCompletion: successHandler)
    }
}
