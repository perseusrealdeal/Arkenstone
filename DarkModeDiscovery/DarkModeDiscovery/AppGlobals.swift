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
// import PerseusGeoKit

// MARK: - Geo Constants

var DEFAULT_GEO_POINT: String { "\(DEFAULT_MAP_POINT.point)" }
var CURRENT_GEO_POINT: String {

    guard let point = AppGlobals.currentLocation else {
        return "Latitude, Longitude"
    }

    return "\(point)"
}

var CURRENT_LOCATION: String {
    return AppGlobals.currentLocation == nil ? DEFAULT_GEO_POINT : CURRENT_GEO_POINT
}

// MARK: - App Globals

struct AppGlobals {

    // MARK: - Business Data

    static var currentLocation: GeoPoint? {
        didSet {
            let location = currentLocation?.description ?? "current location is erased"
            log.message("\(location) \(#function)", .info)
            log.message("\(location)", .debug, .custom)
        }
    }

    // MARK: - System Services

    static let notificationCenter = NotificationCenter.default

    // MARK: - Initializer

    init() {
        log.message("[\(type(of: self))].\(#function)", .info)

        GeoAgent.currentAccuracy = PREFERED_ACCURACY

        GeoCoordinator.shared.onStatusAllowed = {
            // LocationDealer.requestCurrent()
            LocationDealer.requestUpdatingLocation()
        }
        GeoCoordinator.shared.notifier = AppGlobals.notificationCenter

        GeoCoordinator.shared.locationRecieved = { point in
            AppGlobals.currentLocation = point
        }

        GeoCoordinator.shared.locationUpdatesRecieved = { updates in
            if let thelastone = updates.last {
                log.message("recieved location updates: \(updates.count)")
                log.message("recieved location updates: \(updates.count)", .debug, .custom)
                AppGlobals.currentLocation = thelastone
            }
        }
    }
}
