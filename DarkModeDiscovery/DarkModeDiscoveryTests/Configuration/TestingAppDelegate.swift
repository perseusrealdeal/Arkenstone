//
//  TestingAppDelegate.swift
//  DarkModeDiscoveryTests
//
//  Created by Mikhail A. Zhigulin of Novosibirsk.
//
//  Unlicensed Free Software.
//

import XCTest

import ConsolePerseusLogger
@testable import Arkenstone

// MARK: - The Testing Application Delegate

@objc(TestingAppDelegate)
class TestingAppDelegate: NSResponder, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        log.output = .standard

        log.message("The app's test bundle start point...", .info)
        log.message("Launching with testing matter purpose...", .info)

        log.message("[\(type(of: self))].\(#function)")
    }
}
