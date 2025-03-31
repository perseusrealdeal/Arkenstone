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

class MapViewController: NSViewController {

    @IBOutlet private(set) weak var mapView: MKMapView!

    @IBOutlet private(set) weak var labelCoordinate: NSTextField!
    @IBOutlet private(set) weak var labelGeoStatus: NSTextField!

    @IBAction func actionButtonStopTapped(_ sender: NSButton) {
        log.message("\(#function)")
    }

    @IBAction func actionButtonStartTapped(_ sender: NSButton) {
        log.message("\(#function)")
    }

    @IBAction func actionButtonCurrentTapped(_ sender: NSButton) {
        log.message("\(#function)")
    }

    @IBAction func actionButtonGoToPointTapped(_ sender: NSButton) {
        guard let location = AppGlobals.currentLocation else {
            labelCoordinate.stringValue = DEFAULT_GEO_POINT
            mapView.setRegion(DEFAULT_VISIBLE_REGION, animated: true)
            return
        }

        let point = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let region = MKCoordinateRegion(center: point.coordinate,
                                        latitudinalMeters: DEFAULT_MAP_RADIUS,
                                        longitudinalMeters: DEFAULT_MAP_RADIUS)

        mapView.setRegion(region, animated: true)
        // mapView.showsUserLocation = true
    }

    @IBAction func actionButtonRefreshStatusTapped(_ sender: NSButton) {
        log.message("\(#function)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the defualt visible area

        mapView.setRegion(DEFAULT_VISIBLE_REGION, animated: true)
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        self.view.wantsLayer = true
        self.parent?.view.window?.title = self.title!

        refresh()
    }

    private func refresh() {
        let permit = "\(globals.locationDealer.locationPermit)".capitalized

        labelGeoStatus.stringValue = permit
        labelCoordinate.stringValue = CURRENT_LOCATION
    }
}
