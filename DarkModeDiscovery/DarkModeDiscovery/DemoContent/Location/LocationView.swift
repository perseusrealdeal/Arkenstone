//
//  LocationView.swift
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
import PerseusGeoKit
import PerseusDarkMode

@IBDesignable
class LocationView: NSView {

    private let theDarknessTrigger = DarkModeObserver()

    @IBOutlet private(set) var viewContent: NSView!

    @IBOutlet private(set) weak var labelGeoStatus: NSTextField!
    @IBOutlet private(set) weak var labelCoordinate: NSTextField!

    @IBOutlet private(set) weak var buttonRefresh: NSButton!

    // MARK: - Actions

    @IBAction func buttonRefreshStatusTapped(_ sender: NSButton) {
        labelGeoStatus.stringValue = "\(GeoAgent.currentStatus)".capitalized
        LocationDealer.requestPermission()
    }

    @IBAction func buttonRefreshCurrentTapped(_ sender: NSButton) {
        LocationDealer.requestCurrent()
    }

    // MARK: - Initialization

    required public init?(coder: NSCoder) {
        super.init(coder: coder)

        // Setup the view as a reusable control.

        guard let className = type(of: self).className().components(separatedBy: ".").last,
              let nib = NSNib(nibNamed: className, bundle: Bundle(for: type(of: self)))
        else {
            let text = "[\(type(of: self))].\(#function) no nib loaded"
            log.message(text, .fault); fatalError(text)
        }

        nib.instantiate(withOwner: self, topLevelObjects: nil)

        var newConstraints: [NSLayoutConstraint] = []

        for oldConstraint in viewContent.constraints {

            let firstItem = oldConstraint.firstItem === viewContent ?
            self : oldConstraint.firstItem

            let secondItem = oldConstraint.secondItem === viewContent ?
            self : oldConstraint.secondItem

            newConstraints.append(
                NSLayoutConstraint(item: firstItem as Any,
                                   attribute: oldConstraint.firstAttribute,
                                   relatedBy: oldConstraint.relation,
                                   toItem: secondItem,
                                   attribute: oldConstraint.secondAttribute,
                                   multiplier: oldConstraint.multiplier,
                                   constant: oldConstraint.constant)
            )
        }

        for newView in viewContent.subviews {
            self.addSubview(newView)
        }

        self.addConstraints(newConstraints)

        // Connect to Geo Coordinator
        GeoCoordinator.register(stakeholder: self, selector: #selector(reload))

        // Connect to Dark Mode explicitly
        theDarknessTrigger.action = { _ in self.makeUp() }
    }
}

// MARK: - Implementation

extension LocationView {

    @objc private func reload() {
        labelGeoStatus.stringValue = "\(GeoAgent.currentStatus)".capitalized
        labelCoordinate.stringValue = CURRENT_GEO_POINT
    }

    private func makeUp() {
        log.message("[\(type(of: self))].\(#function)")

        labelGeoStatus.textColor = .customLabel
        labelCoordinate.textColor = .customLabel
    }
}
