//
//  GeoCoordinator.swift
//  Arkenstone
//
//  Created by Mikhail Zhigulin in 7533 (31.03.2025).
//
//  Copyright © 7531 - 7533 Mikhail A. Zhigulin of Novosibirsk
//  Copyright © 7531 - 7533 PerseusRealDeal
//
//  Licensed under the special license. See LICENSE file.
//  All rights reserved.
//

import Foundation

import ConsolePerseusLogger
import PerseusGeoKit

class GeoCoordinator: NSObject {

    // MARK: - Geo Components

    public var locationView: LocationView?
    public var mapViewController: MapViewController?

    // MARK: - Singletone

    public static let shared: GeoCoordinator = { return GeoCoordinator() }()

    private override init() {

        log.message("[\(GeoCoordinator.self)].\(#function)", .info)

        super.init()

        GeoAgent.register(self, #selector(locationErrorHandler(_:)), .locationError)
        GeoAgent.register(self, #selector(locationStatusHandler(_:)), .locationStatus)
        GeoAgent.register(self, #selector(currentLocationHandler(_:)), .currentLocation)
        GeoAgent.register(self, #selector(locationUpdatesHandler(_:)), .locationUpdates)
    }

    // MARK: - Contract

    public func reloadGeoComponents() {
        log.message("[\(type(of: self))].\(#function)")
        updateGeoComponents()
    }
}

// MARK: - Implementation

extension GeoCoordinator {
    private func updateGeoComponents() {
        log.message("[\(type(of: self))].\(#function)")
        self.locationView?.reloadData()
        self.mapViewController?.reloadData()
    }
}

// MARK: - Geo Event Handlers

extension GeoCoordinator {

    @objc private func locationErrorHandler(_ notification: Notification) {

        log.message("[\(type(of: self))].\(#function) [EVENT]")
        var errtext = ""

        guard let error = notification.object as? LocationError else {
            errtext = "nothing is about error"
            log.message("[\(type(of: self))].\(#function) \(errtext)", .error)
            return
        }

        switch error {
        case .failedRequest(_, let domain, let code):
            let domaincode = "domain: \(domain), code: \(code)"
            switch code {
            case 0:
                errtext = "hardware issue: try to tap Wi-Fi in system tray, \(domaincode)"
            case 1:
                errtext = "permission required, \(domaincode)"
            default:
                break
            }
        default:
            break
        }

        log.message("[\(type(of: self))].\(#function) \(errtext)", .error)
    }

    @objc private func locationStatusHandler(_ notification: Notification) {

        let status = GeoAgent.currentStatus
        log.message("[\(type(of: self))].\(#function) status: \(status) [EVENT]")

        updateGeoComponents()

        if status == .allowed {
            LocationDealer.requestCurrent()
        }
    }

    @objc private func currentLocationHandler(_ notification: Notification) {

        log.message("[\(type(of: self))].\(#function) [EVENT]")

        var errtext = ""
        var location: GeoPoint?

        guard let result = notification.object as? Result<GeoPoint, LocationError> else {
            errtext = "nothing is about location"
            log.message("[\(type(of: self))].\(#function) \(errtext)", .error)
            return
        }

        switch result {
        case .success(let point):
            location = point
        case .failure(let error):
            errtext = "\(error)"
        }

        if let current = location {
            AppGlobals.currentLocation = current
        } else if !errtext.isEmpty {
            log.message("[\(type(of: self))].\(#function) \(errtext)", .error)
        }

        updateGeoComponents()
    }

    @objc private func locationUpdatesHandler(_ notification: Notification) {
        log.message("[\(type(of: self))].\(#function) [EVENT]")

        var errtext = ""
        var updates: [GeoPoint]?

        guard let result = notification.object as? Result<[GeoPoint], LocationError> else {
            errtext = "nothing is about location updates"
            log.message("[\(type(of: self))].\(#function) \(errtext)", .error)
            return
        }

        switch result {
        case .success(let points):
            updates = points
        case .failure(let error):
            errtext = "\(error)"
        }

        if updates != nil {
            // Location updates are here!
        } else if !errtext.isEmpty {
            log.message("[\(type(of: self))].\(#function) \(errtext)", .error)
        }

        updateGeoComponents()
    }
}
