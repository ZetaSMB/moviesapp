//
//  LaunchInstructor.swift
//  movies
//
//  Created by Santiago B on 13/04/2019.
//  Copyright © 2019 zeta. All rights reserved.
//

import Foundation

enum LaunchInstructor {
    
    case auth
    case main
    
    // MARK: - Public methods
    
    static func configure(isAutorized: Bool = false) -> LaunchInstructor {
        if isAutorized {
            return .main
        } else {
            return .auth
        }
    }
    
}
