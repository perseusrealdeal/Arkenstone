//
//  PGKSupportingStar.swift
//  Version: 1.0.0
//
//  PerseusGeoKit Support Code
//
//
//  For iOS and macOS only. Use Stars to adopt for the specifics you need.
//
//  Created by Mikhail Zhigulin of Novosibirsk in 7533.
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year.
//
//
//  Unlicensed Free Software
//
//  This is free and unencumbered software released into the public domain.
//
//  Anyone is free to copy, modify, publish, use, compile, sell, or
//  distribute this software, either in source code form or as a compiled
//  binary, for any purpose, commercial or non-commercial, and by any
//  means.
//
//  In jurisdictions that recognize copyright laws, the author or authors
//  of this software dedicate any and all copyright interest in the
//  software to the public domain. We make this dedication for the benefit
//  of the public at large and to the detriment of our heirs and
//  successors. We intend this dedication to be an overt act of
//  relinquishment in perpetuity of all present and future rights to this
//  software under copyright law.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
//  OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
//  ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  For more information, please refer to <http://unlicense.org/>
//
// swiftlint:disable file_length
//

import ConsolePerseusLogger
// import PerseusGeoKit

#if os(iOS)
import UIKit
#endif
import MapKit

// MARK: - Geo Constants

let PREFERED_ACCURACY: GeoAccuracy = .threeKilometers

let DEFAULT_MAP_POINT = CLLocation(latitude: 55.036857, longitude: 82.914063)
let DEFAULT_MAP_RADIUS: CLLocationDistance = 1000

let DEFAULT_VISIBLE_REGION = MKCoordinateRegion(center: DEFAULT_MAP_POINT.coordinate,
                                                latitudinalMeters: DEFAULT_MAP_RADIUS,
                                                longitudinalMeters: DEFAULT_MAP_RADIUS)

var REDIRECT_ALERT_TITLES = ActionAlertText(
    title: "Location Services.",
    message: "The Current Location Services Status can be changed in System Services.",
    buttonCancel: "OK",
    buttonFunction: "System Services")

extension ActionAlertText {
    var titleWithStatus: String {
        return "Location Services: \(GeoAgent.currentStatus)."
    }
}

extension Notification.Name {
    static let ReloadGeoDataNotification = Notification.Name("ReloadGeoDataNotification")
}

// MARK: - LocationDealer class

class LocationDealer {

    // MARK: - iOS Contract

#if os(iOS)

    public class func requestPermission(_ alertViewController: UIViewController? = nil) {
        GeoAgent.shared.requestPermission { status in
            if status != .allowed, let parentVC = alertViewController {
                REDIRECT_ALERT_TITLES.title = REDIRECT_ALERT_TITLES.titleWithStatus
                GeoAgent.showRedirectAlert(parentVC, REDIRECT_ALERT_TITLES) // Offer redirect.
            }
        }
    }

    public class func requestCurrent(_ alertViewController: UIViewController? = nil) {
        do {
            try GeoAgent.shared.requestCurrentLocation()
        } catch LocationError.permissionRequired(let status) { // Permission required.

            log.message("[\(type(of: self))].\(#function) permission required", .notice)

            if status == .notDetermined {
                GeoAgent.shared.requestPermission() // Request permission.
            } else if let parentVC = alertViewController {
                REDIRECT_ALERT_TITLES.title = REDIRECT_ALERT_TITLES.titleWithStatus
                GeoAgent.showRedirectAlert(parentVC, REDIRECT_ALERT_TITLES) // Offer redirect.
            }

        } catch {
            log.message("[\(type(of: self))].\(#function) something went wrong", .error)
        }
    }

    public class func requestUpdatingLocation(_ alertViewController: UIViewController? = nil) {
        do {
            try GeoAgent.shared.requestUpdatingLocation()
        } catch LocationError.permissionRequired(let status) { // Permission required.

            if status == .notDetermined {
                GeoAgent.shared.requestPermission() // Request permission.
            } else if let parentVC = alertViewController {
                REDIRECT_ALERT_TITLES.title = REDIRECT_ALERT_TITLES.titleWithStatus
                GeoAgent.showRedirectAlert(parentVC, REDIRECT_ALERT_TITLES) // Offer redirect.
            }

        } catch {
            log.message("[\(type(of: self))].\(#function) something went wrong", .error)
        }
    }

#elseif os(macOS)

    // MARK: - macOS Contract

    public class func requestPermission() {
        GeoAgent.shared.requestPermission { status in
            if status != .allowed {
                REDIRECT_ALERT_TITLES.title = REDIRECT_ALERT_TITLES.titleWithStatus
                GeoAgent.showRedirectAlert(REDIRECT_ALERT_TITLES)  // Offer redirect.
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
                REDIRECT_ALERT_TITLES.title = REDIRECT_ALERT_TITLES.titleWithStatus
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
                REDIRECT_ALERT_TITLES.title = REDIRECT_ALERT_TITLES.titleWithStatus
                GeoAgent.showRedirectAlert(REDIRECT_ALERT_TITLES) // Offer redirect.
            }

        } catch {
            log.message("[\(type(of: self))].\(#function) something went wrong", .error)
        }
    }

#endif

}

// MARK: - GeoCoordinator class

class GeoCoordinator: NSObject {

    // MARK: - Properties

    public var notifier: NotificationCenter?

    public var locationRecieved: ((GeoPoint) -> Void)?
    public var locationUpdatesRecieved: (([GeoPoint]) -> Void)?

    public var onStatusAllowed: (() -> Void)?

    // MARK: - Singletone

    public static let shared = GeoCoordinator()

    private override init() {

        log.message("[\(GeoCoordinator.self)].\(#function)", .info)

        super.init()

        GeoAgent.register(self, #selector(locationErrorHandler(_:)), .locationError)
        GeoAgent.register(self, #selector(locationStatusHandler(_:)), .locationStatus)
        GeoAgent.register(self, #selector(currentLocationHandler(_:)), .currentLocation)
        GeoAgent.register(self, #selector(locationUpdatesHandler(_:)), .locationUpdates)
    }

    // MARK: - Contract

    public static func register(stakeholder: Any, selector: Selector) {
        shared.notifier?.addObserver(stakeholder,
                                     selector: selector,
                                     name: .ReloadGeoDataNotification,
                                     object: nil)
    }

    public static func reloadGeoComponents() {
        log.message("[\(type(of: self))].\(#function)")
        shared.updateGeoComponents()
    }

    // MARK: - Implementation

    private func updateGeoComponents() {
        log.message("[\(type(of: self))].\(#function)")
        self.notifier?.post(name: .ReloadGeoDataNotification, object: nil)
    }

    // MARK: - Event Handlers

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

        guard let sysStatus = notification.object as? CLAuthorizationStatus else {
            let errtext = "nothing is about status event"
            log.message("[\(type(of: self))].\(#function) \(errtext)", .error)
            return
        }

        let lmStatus = GeoAgent.aboutLocationServices().auth

        if lmStatus != sysStatus {
            let statues = "lm status: \(lmStatus), system status: \(sysStatus)"
            log.message("[\(type(of: self))].\(#function) \(statues)", .error)
        }

        let status = GeoAgent.currentStatus

        log.message("[\(type(of: self))].\(#function) currentStatus: \(status) [EVENT]")

        updateGeoComponents()

        if status == .allowed {
            onStatusAllowed?()
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
            locationRecieved?(current)
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

        if let updates = updates {
            locationUpdatesRecieved?(updates)
        } else if !errtext.isEmpty {
            log.message("[\(type(of: self))].\(#function) \(errtext)", .error)
        }

        updateGeoComponents()
    }
}
