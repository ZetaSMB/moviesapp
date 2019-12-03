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
    
    func login(username: String, password: String, completionHandler: @escaping AuthCompletionBlock) {
        let creds = SyncCredentials.usernamePassword(username: username, password: password, register: false)
        SyncUser.logIn(with: creds, server: RealmConstants.AUTH_URL) { (RLMSyncUser, Error) in
            if RLMSyncUser != nil {
                completionHandler(.success(()))
            }
            if let err = Error as NSError? {
                completionHandler(.failure(err.code == 611 ? AuthError.userOrPasswordDoesNotExist : AuthError.realmError(err)))
            }
            completionHandler(.failure(AuthError.unkownError))
        }
    }
    
    func registerUser(username: String, password: String, completionHandler: @escaping AuthCompletionBlock) {
        let creds = SyncCredentials.usernamePassword(username: username, password: password, register: true)
        SyncUser.logIn(with: creds, server: RealmConstants.AUTH_URL)  { (RLMSyncUser, Error) in
              if let _ = RLMSyncUser {
                  completionHandler(.success(()))
              }
              if let err = Error {
                  completionHandler(.failure(AuthError.realmError(err)))
              }
              completionHandler(.failure(AuthError.unkownError))
          }
    }
    
    func logoutUser() {
        SyncUser.current?.logOut()
    }
}
