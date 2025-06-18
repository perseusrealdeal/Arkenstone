//
//  AppGlobals.swift
//  DarkModeDiscovery
//
//  Created by Mikhail A. Zhigulin of Novosibirsk.
//
//  Unlicensed Free Software.
//

import Cocoa

import ConsolePerseusLogger
import PerseusGeoKit

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
            geolog.message("\(location) \(#function)", .debug, .custom)
        }
    }

    // MARK: - System Services

    static let notificationCenter = NotificationCenter.default

    // MARK: - Initializer

    init() {
        log.message("[\(type(of: self))].\(#function)", .info)

        GeoAgent.currentAccuracy = DEFAULT_ACCURACY

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
                log.message("Location Updates: \(updates.count)")
                geolog.message("Location Updates: \(updates.count)", .debug, .custom)
                AppGlobals.currentLocation = thelastone
            }
        }
    }
}
