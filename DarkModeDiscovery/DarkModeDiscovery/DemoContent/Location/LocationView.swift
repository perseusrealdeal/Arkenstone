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

    let darkModeObserver = DarkModeObserver()

    @IBOutlet private(set) var viewContent: NSView!

    @IBOutlet private(set) weak var labelPermissionValue: NSTextField!
    @IBOutlet private(set) weak var labelGeoCoupleValue: NSTextField!

    @IBOutlet private(set) weak var buttonRefresh: NSButton!

    // MARK: - Actions

    @IBAction func buttonRefreshStatusTapped(_ sender: NSButton) {
        let dealer = globals.locationDealer

        labelPermissionValue.stringValue = "\(dealer.locationPermit)".capitalized

        dealer.requestPermission { permit in
            if permit != .allowed {
                dealer.alert.show()
            }
        }
    }

    @IBAction func buttonRefreshCurrentTapped(_ sender: NSButton) {
        let dealer = globals.locationDealer

        do {
            try dealer.requestCurrentLocation()
        } catch LocationError.permissionRequired(let permit) {

            log.message("[\(type(of: self))].\(#function) - permission required", .notice)

            if permit == .notDetermined {
                dealer.requestPermission()
            } else {
                dealer.alert.show()
            }

        } catch {
            log.message("[\(type(of: self))].\(#function) - something totally wrong", .error)
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

        LocationAgent.getNotified(with: self,
                                  selector: #selector(locationDealerCurrentHandler(_:)),
                                  name: .locationDealerCurrentNotification)

        LocationAgent.getNotified(with: self,
                                  selector: #selector(locationDealerStatusChangedHandler),
                                  name: .locationDealerStatusChangedNotification)

        LocationAgent.getNotified(with: self,
                                  selector: #selector(locationDealerErrorHandler(_:)),
                                  name: .locationDealerErrorNotification)

        // Setup Dark Mode event handlers.

        darkModeObserver.action = { _ in self.callDarkModeSensitiveColours() }

        callDarkModeSensitiveColours()
    }

    // MARK: - Contract

    public func update() {
        refresh()
    }
}

extension LocationView {

    @objc private func locationDealerCurrentHandler(_ notification: Notification) {
        log.message("[\(type(of: self))]:[EVENT].\(#function)", .info)

        guard
            let result = notification.object as? Result<PerseusLocation, LocationError>
        else {
            log.message("[\(type(of: self))]:[EVENT].\(#function)", .error)
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
        log.message("[\(type(of: self))]:[EVENT].\(#function)", .info)
        refresh()
    }

    @objc private func locationDealerErrorHandler(_ notification: Notification) {
        log.message("[\(type(of: self))]:[EVENT].\(#function)", .info)

        guard
            let result = notification.object as? LocationError,
            let failedRequestDetails = result.failedRequestDetails
        else {
            log.message("[\(type(of: self))].\(#function) - no error details", .error)
            return
        }

        switch failedRequestDetails.code {
        case 0: log.message("Wireless issue takes place. Try tap Wi-Fi.", .notice)
        case 1: log.message("Permission deal required.", .notice)
        default:
            break
        }
    }

    private func refresh() {
        let permit = "\(globals.locationDealer.locationPermit)".capitalized

        labelPermissionValue.stringValue = permit
        labelGeoCoupleValue.stringValue = CURRENT_GEO_POINT
    }

    private func callDarkModeSensitiveColours() {
        labelPermissionValue.textColor = .customLabel
        labelGeoCoupleValue.textColor = .customLabel
    }
}
