//
//  Storyboard.swift
//  movies
//
//  Created by Santiago Beltramone on 11/13/19.
//  Copyright © 2019 zeta. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    // MARK: - Vars & Lets
    
    static var main: UIStoryboard {
        return UIStoryboard.init(name: "Main", bundle: nil)
    }
    
    static var auth: UIStoryboard {
        return UIStoryboard.init(name: "Auth", bundle: nil)
    }    
}
