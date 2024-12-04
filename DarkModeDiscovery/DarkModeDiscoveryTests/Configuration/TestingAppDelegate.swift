//
//  TestingAppDelegate.swift
//  DarkModeDiscoveryTests
//
//  Created by Mikhail Zhigulin in 7530.
//
//  Copyright © 7530 - 7533 Mikhail A. Zhigulin of Novosibirsk
//  Copyright © 7530 - 7533 PerseusRealDeal
//
//  Licensed under the special license. See LICENSE file.
//  All rights reserved.
//

import XCTest
import ConsolePerseusLogger

@testable import DarkModeDiscovery

// MARK: - The Testing Application Delegate

@objc(TestingAppDelegate)
class TestingAppDelegate: NSResponder, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        log.message("Launching with testing matter purpose", .info)
        log.message("[\(type(of: self))].\(#function)")
    }
}
