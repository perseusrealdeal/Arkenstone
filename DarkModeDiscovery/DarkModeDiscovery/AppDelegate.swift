//
//  AppDelegate.swift
//  DarkModeDiscovery
//
//  Created by Mikhail A. Zhigulin of Novosibirsk.
//
//  Unlicensed Free Software.
//

import Cocoa

import ConsolePerseusLogger
import PerseusDarkMode
import PerseusGeoKit

class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        log.message("Launching with business matter purpose...", .info)
        log.message("[\(type(of: self))].\(#function)")

        DarkModeAgent.force(DarkModeUserChoice)
        GeoCoordinator.reloadGeoComponents()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {

        log.message("[\(type(of: self))].\(#function)", .info)
        NSApplication.shared.terminate(self)

        return true
    }
}
