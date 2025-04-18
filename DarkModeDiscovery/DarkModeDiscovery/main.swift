//
//  main.swift
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

import Cocoa
import ConsolePerseusLogger

// import class PerseusDarkMode.PerseusLogger
import class PerseusGeoKit.PerseusLogger

// swiftlint:disable type_name
// typealias dmlog = PerseusDarkMode.PerseusLogger
typealias geolog = PerseusGeoKit.PerseusLogger
// swiftlint:enable type_name

// MARK: - Logger

// log.output = .consoleapp
// dmlog.output = .consoleapp
// geolog.output = .consoleapp

// geolog.turned = .off

// MARK: - Construct the app's top elements

log.message("The app's start point...", .info)

let app = NSApplication.shared

let appPurpose = NSClassFromString("TestingAppDelegate") as? NSObject.Type
let appDelegate = appPurpose?.init() ?? AppDelegate()

let globals = AppGlobals()

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

        let height: CGFloat = 500 // Default main window height
        let width: CGFloat = 500 // Default main window width

        let origin_x = screen.frame.size.width / 2 - width / 2
        let origin_y = screen.frame.size.height / 2 - height / 2

        frame.size = NSSize(width: width, height: height)
        frame.origin = NSPoint(x: origin_x, y: origin_y)

        NSApplication.shared.windows.first?.setFrame(frame, display: true)
    }
}
