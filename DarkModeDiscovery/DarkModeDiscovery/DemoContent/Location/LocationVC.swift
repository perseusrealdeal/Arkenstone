//
//  LocationVC.swift
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

class LocationViewController: NSViewController {

    @IBOutlet private(set) weak var mapView: MKMapView!

    @IBOutlet private(set) weak var buttonStop: NSButton!
    @IBOutlet private(set) weak var buttonStart: NSButton!
    @IBOutlet private(set) weak var buttonCurrent: NSButton!
    @IBOutlet private(set) weak var buttonGoToPoint: NSButton!
    @IBOutlet private(set) weak var buttonRefreshStatus: NSButton!

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
        log.message("\(#function)")
    }

    @IBAction func actionButtonRefreshStatusTapped(_ sender: NSButton) {
        log.message("\(#function)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the defualt visible area

        let point = CLLocation(latitude: 55.036857, longitude: 82.914063)
        let radius: CLLocationDistance = 1000

        let region = MKCoordinateRegion(center: point.coordinate,
                                        latitudinalMeters: radius,
                                        longitudinalMeters: radius)

        mapView.setRegion(region, animated: true)
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        self.view.wantsLayer = true
        // self.view.layer?.backgroundColor = NSColor.blue.cgColor

        self.parent?.view.window?.title = self.title!
    }
}
