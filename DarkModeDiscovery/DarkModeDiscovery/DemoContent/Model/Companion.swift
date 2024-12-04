//
//  Companion.swift, companions.json
//  DarkModeDiscovery
//
//  Created by Mikhail Zhigulin in 7530.
//
//  Copyright © 7530 - 7533 Mikhail A. Zhigulin of Novosibirsk
//  Copyright © 7530 - 7533 PerseusRealDeal
//
//  Licensed under the special license. See LICENSE file.
//  All rights reserved.
//

import Foundation

/// Represents a companion of the company.
struct Companion: Decodable {
    let name: String
    let age: String
    let race: Race
    let iconName: String
    let characteristics: String
}
