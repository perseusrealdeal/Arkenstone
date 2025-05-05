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

    private let darkModeObserver = DarkModeObserver()

    @IBOutlet private(set) var viewContent: NSView!

    @IBOutlet private(set) weak var labelPermissionValue: NSTextField!
    @IBOutlet private(set) weak var labelGeoCoupleValue: NSTextField!

    @IBOutlet private(set) weak var buttonRefresh: NSButton!

    // MARK: - Actions

    @IBAction func buttonRefreshStatusTapped(_ sender: NSButton) {

        labelPermissionValue.stringValue = "\(GeoAgent.currentStatus)".capitalized

        GeoAgent.shared.requestPermission { permit in
            if permit != .allowed {
                GeoAgent.showRedirectAlert(REDIRECT_ALERT_TITLES)
            }
        }
    }

    @IBAction func buttonRefreshCurrentTapped(_ sender: NSButton) {
        let dealer = globals.locationDealer

        do {
            try dealer.requestCurrentLocation()
        } catch LocationError.permissionRequired(let permit) {

            log.message("[\(type(of: self))].\(#function) permission required", .notice)

            if permit == .notDetermined {
                dealer.requestPermission()
            } else {
                GeoAgent.showRedirectAlert(REDIRECT_ALERT_TITLES)
            }

        } catch {
            log.message("[\(type(of: self))].\(#function) something went wrong", .error)
        }
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

        // Connect to Geo coordinator
        globals.geoCoordinator.locationView = self

        // Give Dark Mode observer the action
        darkModeObserver.action = { _ in self.makeUp() }
    }

    // MARK: - Contract

    public func reloadData() {
        reload()
    }
}

// MARK: - Implementation

extension LocationView {

    private func reload() {
        labelPermissionValue.stringValue = "\(GeoAgent.currentStatus)".capitalized
        labelGeoCoupleValue.stringValue = CURRENT_GEO_POINT
    }

    private func makeUp() {
        log.message("[\(type(of: self))].\(#function)")

        labelPermissionValue.textColor = .customLabel
        labelGeoCoupleValue.textColor = .customLabel
    }
}
