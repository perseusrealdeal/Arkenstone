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
            let location = currentLocation?.description ?? "current location is erased"
            log.message("\(location) [\(type(of: self))].\(#function)", .info)
        }
    }

    // MARK: - Constants

    static let preferedAccuracy = LocationAccuracy.threeKilometers

    // MARK: - System Services

    static let notificationCenter = NotificationCenter.default

    // MARK: - Custom Services

    public let locationDealer: LocationAgent

    // MARK: - Initializer

    init() {
        log.message("[\(type(of: self))].\(#function)", .info)

        locationDealer = LocationAgent.shared

        // Configure accuracy

        var lm = locationDealer.locationManager
        lm?.desiredAccuracy = AppGlobals.preferedAccuracy.rawValue

        // Configure GoTo Settings alert
        let text = OneFunctionAlertText(title: "Custom Title",
                                        message: "Custom Message",
                                        buttonCancel: "MyCancel",
                                        buttonFunction: "MyAction")

        locationDealer.alert.titles = text
    }
}
