//
//  AppGlobals.swift
//  DarkModeDiscovery
//
//  Created by Mikhail Zhigulin in 7533 (09.12.2024).
//
//  Copyright © 7533 Mikhail A. Zhigulin of Novosibirsk
//  Copyright © 7533 PerseusRealDeal
//
//  Licensed under the special license. See LICENSE file.
//  All rights reserved.
//

import Cocoa

import ConsolePerseusLogger
import PerseusGeoLocationKit

struct AppGlobals {

    // MARK: - Business Data

    static var currentLocation: PerseusLocation? {
        didSet {
            let location = currentLocation?.description ?? "current location is cleared"
            log.message("\(location) [\(type(of: self))].\(#function)", .info)
        }
    }

    // MARK: - Constants

    static let systemApp = "x-apple.systempreferences:"

    // MARK: - System Services

    static let notificationCenter = NotificationCenter.default

    // MARK: - Custom Services

    public let locationDealer: PerseusLocationDealer

    // MARK: - Initializer

    init() {
        log.message("[\(type(of: self))].\(#function)", .info)

        locationDealer = PerseusLocationDealer.shared
    }

    // MARK: - Contract

    static func openTheApp(name: String) {

        guard let pathURL = URL(string: name)
        else {
            log.message("[\(type(of: self))].\(#function)", .error)
            return
        }

        NSWorkspace.shared.open(pathURL)
    }
}
