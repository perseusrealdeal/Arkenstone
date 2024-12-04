//
//  Race.swift
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

/// Represents a set of races faced in the story of the middle-earth.
enum Race: String, Decodable {
    case hobbits
    case ainur
    case dwarves

    /// The one of the race.
    var single: String {
        switch self {
        case .hobbits:
            return "hobbit"
        case .ainur:
            return "wizard"
        case .dwarves:
            return "dwarf"
        }
    }
}
