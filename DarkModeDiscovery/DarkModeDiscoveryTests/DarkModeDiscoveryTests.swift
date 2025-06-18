//
//  DarkModeDiscoveryTests.swift
//  DarkModeDiscoveryTests
//
//  Created by Mikhail A. Zhigulin of Novosibirsk.
//
//  Unlicensed Free Software.
//

import XCTest
import ConsolePerseusLogger

@testable import Arkenstone

class DarkModeDiscoveryTests: XCTestCase {

    override static func setUp() {
        super.setUp()

        log.time = true
        // log.pidtid = true
    }
/*
    override static func tearDown() {
        super.tearDown()
    }

    func test_zero() { XCTFail("Tests not yet implemented in \(type(of: self)).") }
*/
    func test_the_first_success() {
        log.message("[\(type(of: self))].\(#function)")
    }
}
