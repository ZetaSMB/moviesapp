//
//  UIDataError.swift
//  movies
//
//  Created by Santiago on 11/15/19.
//  Copyright © 2019 zeta. All rights reserved.
//

import Foundation

struct UserPrintableError: Error {
    let title: String?
    let message: String
}
