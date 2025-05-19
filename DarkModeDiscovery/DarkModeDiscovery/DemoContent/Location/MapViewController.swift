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

import AppKit
import MapKit

import ConsolePerseusLogger
import PerseusGeoKit

class MapViewController: NSViewController {

    @IBOutlet private(set) weak var mapView: MKMapView!

    @IBOutlet private(set) weak var textScrollViewLog: NSScrollView!
    @IBOutlet private(set) weak var textViewLog: NSTextView!

    @IBOutlet private(set) weak var checkButtonAutoMapToCurrent: NSButton!

    private var observation: NSKeyValueObservation?
    private var autoMapToCurrent = true

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

    @IBAction func actionButtonAutoMapTapped(_ sender: NSButton) {
        autoMapToCurrent = sender.state == .off ? false : true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        textViewLog.backgroundColor = .clear
        textViewLog.textColor = .darkGray

        checkButtonAutoMapToCurrent.state = autoMapToCurrent ? .on : .off

        // Connect to Geo Coordinator
        GeoCoordinator.register(stakeholder: self, selector: #selector(reload))

        // Connect to Log Reporting
        observation = geoReport.observe(\.lastMessage, options: .new) { _, _ in
            self.refreshLogReportTextView()
        }

        textScrollViewLog.isHidden = true
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

        refreshLogReportTextView()
    }
}

// MARK: - Implementation

extension MapViewController {

    @objc private func reload() {
        labelGeoStatus.stringValue = "\(GeoAgent.currentStatus)".capitalized
        labelCoordinate.stringValue = CURRENT_LOCATION

        if autoMapToCurrent {
            mapToCurrent()
        }
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

    private func refreshLogReportTextView() {
        // textViewLog.string = geoReport.text

        // TODO: - Scroll to bottom
    }
}
