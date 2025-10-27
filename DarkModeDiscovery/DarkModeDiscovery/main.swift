//
//  main.swift
//  DarkModeDiscovery
//
//  Created by Mikhail A. Zhigulin of Novosibirsk.
//
//  Unlicensed Free Software.
//

import Cocoa
import ConsolePerseusLogger

import class PerseusDarkMode.PerseusLogger
import class PerseusGeoKit.PerseusLogger

// swiftlint:disable type_name
typealias DM_LOG = PerseusDarkMode.PerseusLogger
typealias GEO_LOG = PerseusGeoKit.PerseusLogger
// swiftlint:enable type_name

// MARK: - Log Report

// swiftlint:disable:next function_parameter_count
func report(_ text: String,
            _ type: DM_LOG.Level,
            _ localTime: DM_LOG.LocalTime,
            _ owner: DM_LOG.PIDandTID,
            _ user: DM_LOG.User,
            _ dirs: DM_LOG.Directives) {

    localReport.lastMessage = "[\(localTime.date)] [\(localTime.time)] \(text)"
}

// swiftlint:disable:next function_parameter_count
func report(_ text: String,
            _ type: GEO_LOG.Level,
            _ localTime: GEO_LOG.LocalTime,
            _ owner: GEO_LOG.PIDandTID,
            _ user: GEO_LOG.User,
            _ dirs: GEO_LOG.Directives) {

    localReport.lastMessage = "[\(localTime.date)] [\(localTime.time)] \(text)"
}

let localReport = ConsolePerseusLogger.PerseusLogger.Report()

// MARK: - Logger

GEO_LOG.customActionOnMessage = report(_:_:_:_:_:_:)
DM_LOG.customActionOnMessage = report(_:_:_:_:_:_:)

log.customActionOnMessage = localReport.report(_:_:_:_:_:_:)

GEO_LOG.output = .custom
DM_LOG.output = .custom
log.output = .custom

// log.turned = .off
// dmlog.turned = .off
// geolog.turned = .off

log.message("The app's start point...", .info, .custom)

/*
var isLoadedInfo = ""

if let path = Bundle.main.url(forResource: "CPLConfig", withExtension: "json") {
    if log.loadConfig(path), dmlog.loadConfig(path), geolog.loadConfig(path) {
        isLoadedInfo = "Options successfully reseted!"
    } else {
        isLoadedInfo = "Failed to reset options!"
    }
} else {
    isLoadedInfo = "Failed to create URL!"
}

log.message(isLoadedInfo)
*/

log.message("The app's start point...", .info)

// MARK: - Construct the app's top elements

let globals = AppGlobals()

let app = NSApplication.shared

let appPurpose = NSClassFromString("TestingAppDelegate") as? NSObject.Type
let appDelegate = appPurpose?.init() ?? AppDelegate()

let storyboard = NSStoryboard(name: String(describing: MainWindowController.self), bundle: nil)
let screen = storyboard.instantiateInitialController() as? NSWindowController
let mainMenu = NSNib(nibNamed: NSNib.Name("MainMenu"), bundle: nil)

// setMainWindow()

// MARK: - Run the app

/*

 .accessory

 The application doesn’t appear in the Dock and doesn’t have a menu bar, but it may be
 activated programmatically or by clicking on one of its windows.

 */

app.setActivationPolicy(.regular)

mainMenu?.instantiate(withOwner: app, topLevelObjects: nil)
screen?.window?.makeKeyAndOrderFront(nil)

app.delegate = appDelegate as? NSApplicationDelegate

app.activate(ignoringOtherApps: true)
app.run()

// MARK: - Custom Main Window

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
