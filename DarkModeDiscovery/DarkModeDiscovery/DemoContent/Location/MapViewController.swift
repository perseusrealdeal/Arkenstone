//
//  MapViewController.swift, Map.storyboard
//  Arkenstone
//
//  Created by Mikhail A. Zhigulin of Novosibirsk.
//
//  Unlicensed Free Software.
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

    @IBOutlet private(set) weak var labelAboutStatus: NSTextField!

    @IBAction func buttonAboutStatusTapped(_ sender: NSButton) {

        let status = GeoAgent.aboutLocationServices()

        let locationServicesStatus = "enabled: \(status.enabled), auth: \(status.auth)"
        let currentStatusDetails = "\(GeoAgent.currentStatus)"

        labelAboutStatus.stringValue = "\(currentStatusDetails) = \(locationServicesStatus)"
    }

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
        if GeoAgent.currentStatus == .allowed {
            REDIRECT_ALERT_TITLES.title = REDIRECT_ALERT_TITLES.titleWithStatus
            GeoAgent.showRedirectAlert(REDIRECT_ALERT_TITLES)  // Offer redirect.
        } else {
            LocationDealer.requestPermission()
        }
    }

    @IBAction func actionButtonAutoMapTapped(_ sender: NSButton) {
        autoMapToCurrent = sender.state == .off ? false : true
    }

    @IBAction func actionButtonReinitTapped(_ sender: NSButton) {
        GeoAgent.reInit()
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

        mapView.showsUserLocation = true

        guard let location = AppGlobals.currentLocation else { return }

        let point = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let region = MKCoordinateRegion(center: point.coordinate,
                                        latitudinalMeters: DEFAULT_MAP_RADIUS,
                                        longitudinalMeters: DEFAULT_MAP_RADIUS)

        mapView.setRegion(region, animated: true)
    }

    private func refreshLogReportTextView() {
        // textViewLog.string = geoReport.text

        // TODO: - Scroll to bottom
    }
}
