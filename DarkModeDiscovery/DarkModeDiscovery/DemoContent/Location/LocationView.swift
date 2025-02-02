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
import PerseusGeoLocationKit
import PerseusDarkMode

@IBDesignable
class LocationView: NSView {

    let darkModeObserver = DarkModeObserver()

    @IBOutlet private(set) var viewContent: NSView!

    @IBOutlet private(set) weak var labelPermissionValue: NSTextField!
    @IBOutlet private(set) weak var labelGeoCoupleValue: NSTextField!

    @IBOutlet private(set) weak var buttonRefresh: NSButton!

    // MARK: - Actions

    @IBAction func buttonRefreshStatusTapped(_ sender: NSButton) {
        let permit = globals.locationDealer.locationPermit
        labelPermissionValue.stringValue = "\(permit)".capitalized

        log.message("Location access \(permit)")

        guard permit != .allowed else { return }

        let dealer = globals.locationDealer

        if permit == .notDetermined {
            // Deal with permission
            dealer.requestPermission()
        } else {
            // Show GoTo Settings alert
            dealer.alert.show()
        }
    }

    @IBAction func buttonRefreshTapped(_ sender: NSButton) {
        let permit = globals.locationDealer.locationPermit

        log.message("Location access \(permit)")

        if permit == .notDetermined {
            // Deal with permission
            globals.locationDealer.requestPermission()
        } else if permit == .allowed {
            // Request current location
            try? globals.locationDealer.requestCurrentLocation()
        } else {
            // Show Goto Setting alert
            globals.locationDealer.alert.show()
        }
    }

    // MARK: - Initialization

    required public init?(coder: NSCoder) {
        super.init(coder: coder)

        // Setup the view as a reusable control.

        guard let className = type(of: self).className().components(separatedBy: ".").last,
              let nib = NSNib(nibNamed: className, bundle: Bundle(for: type(of: self)))
        else {
            let text = "[\(type(of: self))].\(#function) No nib loaded."
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

        // Setup location event handlers.

        let nc = AppGlobals.notificationCenter

        nc.addObserver(self, selector: #selector(locationDealerCurrentHandler(_:)),
                       name: .locationDealerCurrentNotification,
                       object: nil)

        nc.addObserver(self, selector: #selector(locationDealerStatusChangedHandler),
                       name: .locationDealerStatusChangedNotification,
                       object: nil)

        darkModeObserver.action = { _ in self.callDarkModeSensitiveColours() }

        callDarkModeSensitiveColours()
    }

    // MARK: - Contract

    public func update() {
        refresh()
    }
}

extension LocationView {

    private var geoCouple: String {
        guard let location = AppGlobals.currentLocation
        else {
            return "Latitude, Longitude"
        }

        return "\(location.latitude.cut(.four)), \(location.longitude.cut(.four))"
    }

    @objc private func locationDealerCurrentHandler(_ notification: Notification) {
        log.message("[\(type(of: self))]:[NOTIFICATION].\(#function)")

        guard
            let result = notification.object as? Result<PerseusLocation, LocationError>
        else {
            log.message("[\(type(of: self))]:[NOTIFICATION].\(#function)", .error)
            return
        }

        switch result {
        case .success(let data):
            AppGlobals.currentLocation = data
        case .failure(let error):
            log.message("\(error)", .error)
        }

        refresh()
    }

    @objc private func locationDealerStatusChangedHandler() {
        log.message("[\(type(of: self))]:[NOTIFICATION].\(#function)")
        refresh()
    }

    private func refresh() {
        let permit = "\(globals.locationDealer.locationPermit)".capitalized

        labelPermissionValue.stringValue = permit
        labelGeoCoupleValue.stringValue = geoCouple
    }

    private func callDarkModeSensitiveColours() {
        labelPermissionValue.textColor = .customLabel
        labelGeoCoupleValue.textColor = .customLabel
    }
}
