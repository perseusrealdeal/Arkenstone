//
//  MapViewController.swift, Map.storyboard
//  Arkenstone
//
//  Created by Mikhail Zhigulin in 7533 (18.03.2025).
//
//  Copyright © 7531 - 7533 Mikhail A. Zhigulin of Novosibirsk
//  Copyright © 7531 - 7533 PerseusRealDeal
//
//  Licensed under the special license. See LICENSE file.
//  All rights reserved.
//

import Cocoa
import MapKit

import ConsolePerseusLogger
import PerseusGeoKit

class MapViewController: NSViewController {

    @IBOutlet private(set) weak var mapView: MKMapView!

    @IBOutlet private(set) weak var labelCoordinate: NSTextField!
    @IBOutlet private(set) weak var labelGeoStatus: NSTextField!

    @IBAction func actionButtonStopTapped(_ sender: NSButton) {
        GeoAgent.shared.stopUpdatingLocation()
    }

    @IBAction func actionButtonStartTapped(_ sender: NSButton) {
        LocationDealer.requestUpdatingLocation()
    }

    @IBAction func actionButtonCurrentTapped(_ sender: NSButton) {
        LocationDealer.requestCurrent()
    }

    @IBAction func actionButtonGoToPointTapped(_ sender: NSButton) {
        mapToCurrent()
    }

    @IBAction func actionButtonRefreshStatusTapped(_ sender: NSButton) {
        labelGeoStatus.stringValue = "\(GeoAgent.currentStatus)".capitalized
        LocationDealer.requestPermission()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Connect to Geo Coordinator
        GeoCoordinator.register(stakeholder: self, selector: #selector(reload))

        log.message("[\(type(of: self))].\(#function)")
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        self.view.wantsLayer = true
        self.parent?.view.window?.title = self.title!

        if AppGlobals.currentLocation == nil {
            labelCoordinate.stringValue = "Default: \(DEFAULT_GEO_POINT)"
            mapView.setRegion(DEFAULT_VISIBLE_REGION, animated: true)
        } else {
            reload()
        }

        log.message("[\(type(of: self))].\(#function)")
    }
}

// MARK: - Implementation

extension MapViewController {
    @objc private func reload() {
        labelGeoStatus.stringValue = "\(GeoAgent.currentStatus)".capitalized
        labelCoordinate.stringValue = CURRENT_LOCATION

        mapToCurrent()
    }

    private func mapToCurrent() {
        guard let location = AppGlobals.currentLocation else { return }

        let point = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let region = MKCoordinateRegion(center: point.coordinate,
                                        latitudinalMeters: DEFAULT_MAP_RADIUS,
                                        longitudinalMeters: DEFAULT_MAP_RADIUS)

        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
}
