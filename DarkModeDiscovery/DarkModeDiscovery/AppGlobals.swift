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

var isHighSierra: Bool { // true HighSierra, false otherwise
    if #available(macOS 10.14, *) {
        return false
    } // For HighSierra.
    return true
}

// MARK: - App Globals

struct AppGlobals {

    // MARK: - Business Data

    static var currentLocation: GeoPoint? {
        didSet {
            let location = currentLocation?.description ?? "current location is erased"
            log.message("\(location) \(#function)", .info)
            GEO_LOG.message("\(location) \(#function)", .debug, .custom)
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
                GEO_LOG.message("Location Updates: \(updates.count)", .debug, .custom)
                AppGlobals.currentLocation = thelastone
            }
        }
    }
}

func loadJsonLogProfile(_ name: String) -> (status: Bool, info: String) {

    if let path = Bundle.main.url(forResource: name, withExtension: "json") {
        if log.loadConfig(path), dmlog.loadConfig(path), geolog.loadConfig(path) {
            return (true, "Options successfully reseted")
        } else {
            return (false, "Failed to reset options")
        }
    } else {
        return (false, "Failed to create URL")
    }
}

// MARK: - Other useful code

/*

func setMainWindow() {
    if let screen = NSScreen.main,
       NSApplication.shared.windows.first?.windowController is MainWindowController,
       var frame = NSApplication.shared.windows.first?.frame {

        let height: CGFloat = 600 // Default main window height
        let width: CGFloat = 800 // Default main window width

        let origin_x = screen.frame.size.width / 2 - width / 2
        let origin_y = screen.frame.size.height / 2 - height / 2

        frame.size = NSSize(width: width, height: height)
        frame.origin = NSPoint(x: origin_x, y: origin_y)

        NSApplication.shared.windows.first?.setFrame(frame, display: true)
    }
}

*/

/*

var tiduint: UInt64 = 0
pthread_threadid_np(nil, &tiduint)

let tid = "0x\(String(format: "%02x", tiduint))"

log.message("The app's start point... TID: \(tid)", .info)

NSLog("NSLog Start: The app's start point... TID: \(tid)")

if #available(macOS 11.0, *) {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "network")
    logger.log("Logger Start: The app's start point... TID: \(tid)")
}

let oslog = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "network")

os_log( "%{public}@", log: oslog,
        "os_log Start: The app's start point... TID: \(tid)")
*/
