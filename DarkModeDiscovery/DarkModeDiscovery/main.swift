//
//  main.swift
//  DarkModeDiscovery
//
//  Created by Mikhail A. Zhigulin of Novosibirsk.
//
//  Unlicensed Free Software.
//

import Foundation
import os

import Cocoa
import ConsolePerseusLogger

import class PerseusDarkMode.PerseusLogger
import class PerseusGeoKit.PerseusLogger

// swiftlint:disable type_name
typealias dmlog = PerseusDarkMode.PerseusLogger
typealias geolog = PerseusGeoKit.PerseusLogger
// swiftlint:enable type_name

// MARK: - Log Reports

class LogReport: NSObject {

    public var text: String { report }

    @objc dynamic var lastMessage: String = "" {
        didSet {
            let count = report.count
            if count > LIMIT {
                report = report.dropFirst(count - LIMIT).description

                if let position = report.range(of: newline)?.upperBound {
                    report.removeFirst(position.utf16Offset(in: report)-2)
                }
            }

            report.append(lastMessage + newline)
        }
    }

    private var report = ""

    private let LIMIT = 1000
    private let newline = "\r\n--\r\n"
}

typealias LogLevel = PerseusGeoKit.PerseusLogger.Level

func report(_ text: String, _ type: LogLevel, _ localTime: LocalTime, _ owner: PIDandTID) {
    geoReport.lastMessage = "[\(localTime.date)] [\(localTime.time)]\r\n> \(text)"
}

let geoReport = LogReport()

// MARK: - Logger

geolog.customActionOnMessage = report(_:_:_:_:)

// log.turned = .off
// dmlog.turned = .off
// geolog.turned = .off

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
