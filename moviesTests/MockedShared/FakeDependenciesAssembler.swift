//
//  FakeDependencyAssembler.swift
//  moviesTests
//
//  Created by Santiago Beltramone on 12/2/19.
//  Copyright © 2019 zeta. All rights reserved.
//

import Foundation
@testable import movies

final class FakeDependenciesAssembler: DependenciesAssembler {
    
    let restAPIrepo: TMDbRepository!
    let authService: AuthServiceProtocol!
    
    func resolveRestApi() -> TMDbRepository {
        return restAPIrepo
    }
    
    func resolveAuthService() -> AuthServiceProtocol {
        return authService
    }
    
    required init(repository: TMDbRepository, _ authService: AuthServiceProtocol ) {
        restAPIrepo = repository
        self.authService = authService
    }
}
