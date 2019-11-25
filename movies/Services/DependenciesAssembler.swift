//
//  DependenciesAssembler.swift
//  movies
//
//  Created by Santiago Beltramone on 11/13/19.
//  Copyright © 2019 zeta. All rights reserved.
//

import Foundation

protocol DependenciesAssembler {
    func resolveRestApi() -> TMDbRepository
    func resolveAuthService() -> AuthServiceProtocol
}

class CoreDependenciesAssembler: DependenciesAssembler {
    func resolveRestApi() -> TMDbRepository {
        return TMDbRepository.shared
    }
    
    func resolveAuthService() -> AuthServiceProtocol {
        return RealmAuthService()
    }
}
