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
import PerseusGeoLocationKit

class GeoCoordinator: NSObject {

    public var locationView: LocationView?
    public var mapViewController: MapViewController?

    // MARK: - Singleton constructor

    public static let shared: GeoCoordinator = { return GeoCoordinator() }()

    private override init() {

        log.message("[\(GeoCoordinator.self)].\(#function)", .info)

        super.init()

        LocationAgent.getNotified(with: self,
                                  selector: #selector(locationDealerCurrentHandler(_:)),
                                  name: .locationDealerCurrentNotification)
        LocationAgent.getNotified(with: self,
                                  selector: #selector(locationDealerStatusChangedHandler),
                                  name: .locationDealerStatusChangedNotification)
        LocationAgent.getNotified(with: self,
                                  selector: #selector(locationDealerErrorHandler(_:)),
                                  name: .locationDealerErrorNotification)
        LocationAgent.getNotified(with: self,
                                  selector: #selector(locationDealerUpdatesHandler(_:)),
                                  name: .locationDealerUpdatesNotification)
    }
}

extension GeoCoordinator {

    @objc private func locationDealerCurrentHandler(_ notification: Notification) {
        log.message("[\(type(of: self))]:[EVENT].\(#function)", .info)
    }

    @objc private func locationDealerStatusChangedHandler() {
        log.message("[\(type(of: self))]:[EVENT].\(#function)", .info)
    }

    @objc private func locationDealerErrorHandler(_ notification: Notification) {
        log.message("[\(type(of: self))]:[EVENT].\(#function)", .info)
    }

    @objc private func locationDealerUpdatesHandler(_ notification: Notification) {
        log.message("[\(type(of: self))]:[EVENT].\(#function)", .info)
    }
}
