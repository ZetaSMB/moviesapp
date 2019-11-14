//
//  RealmConstants.swift
//  movies
//
//  Created by Santiago Beltramone on 11/14/19.
//  Copyright © 2019 zeta. All rights reserved.
//

import Foundation

// swiftlint:disable force_unwrapping
struct RealmConstants {
    static let INSTANCE_ADDRESS = ProcessInfo.processInfo.environment["REALM_INSTANCE_NAME"] ?? ""
    static let AUTH_URL = URL(string: "https://\(INSTANCE_ADDRESS)")!
    static let REALM_CLOUD_URL = URL(string: "realms://\(INSTANCE_ADDRESS)/Movies")!
}
// swiftlint:enable force_unwrapping
