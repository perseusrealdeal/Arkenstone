//
//  Companion.swift, companions.json
//  DarkModeDiscovery
//
//  Created by Mikhail A. Zhigulin of Novosibirsk.
//
//  Unlicensed Free Software.
//

import Foundation

struct Companion: Decodable {
    let name: String
    let age: String
    let race: Race
    let iconName: String
    let characteristics: String
}
