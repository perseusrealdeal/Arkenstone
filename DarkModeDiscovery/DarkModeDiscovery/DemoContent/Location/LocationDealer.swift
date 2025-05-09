//
//  LocationDealer.swift
//  Arkenstone
//
//  Created by Mikhail Zhigulin in 7533 (09.05.2025).
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

class LocationDealer {

    public class func requestPermission() {
        GeoAgent.shared.requestPermission { status in
            if status != .allowed {
                GeoAgent.showRedirectAlert(REDIRECT_ALERT_TITLES)
            }
        }
    }

    public class func requestCurrent() {
        do {
            try GeoAgent.shared.requestCurrentLocation()
        } catch LocationError.permissionRequired(let status) { // Permission required.

            log.message("[\(type(of: self))].\(#function) permission required", .notice)

            if status == .notDetermined {
                GeoAgent.shared.requestPermission() // Request permission.
            } else {
                GeoAgent.showRedirectAlert(REDIRECT_ALERT_TITLES) // Offer redirect.
            }

        } catch {
            log.message("[\(type(of: self))].\(#function) something went wrong", .error)
        }
    }

    public class func requestUpdatingLocation() {
        do {
            try GeoAgent.shared.requestUpdatingLocation()
        } catch LocationError.permissionRequired(let status) { // Permission required.

            if status == .notDetermined {
                GeoAgent.shared.requestPermission() // Request permission.
            } else {
                GeoAgent.showRedirectAlert(REDIRECT_ALERT_TITLES) // Offer redirect.
            }

        } catch {
            log.message("[\(type(of: self))].\(#function) something went wrong", .error)
        }
    }
}
