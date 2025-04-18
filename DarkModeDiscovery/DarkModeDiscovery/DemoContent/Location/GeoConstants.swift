//
//  GeoConstants.swift
//  Arkenstone
//
//  Created by Mikhail Zhigulin in 7533 (30.03.2025).
//
//  Copyright © 7531 - 7533 Mikhail A. Zhigulin of Novosibirsk
//  Copyright © 7531 - 7533 PerseusRealDeal
//
//  Licensed under the special license. See LICENSE file.
//  All rights reserved.
//

import MapKit
import PerseusGeoKit

let PREFERED_ACCURACY = LocationAccuracy.threeKilometers

let DEFAULT_MAP_POINT = CLLocation(latitude: 55.036857, longitude: 82.914063)
let DEFAULT_MAP_RADIUS: CLLocationDistance = 1000

let DEFAULT_VISIBLE_REGION = MKCoordinateRegion(center: DEFAULT_MAP_POINT.coordinate,
                                                latitudinalMeters: DEFAULT_MAP_RADIUS,
                                                longitudinalMeters: DEFAULT_MAP_RADIUS)

var DEFAULT_GEO_POINT: String {

    let lat = DEFAULT_MAP_POINT.coordinate.latitude
    let lon = DEFAULT_MAP_POINT.coordinate.longitude

    return "\(lat.cut(.four)), \(lon.cut(.four))"
}

var CURRENT_GEO_POINT: String {

    guard let point = AppGlobals.currentLocation else {
        return "Latitude, Longitude"
    }

    return "\(point.latitude.cut(.four)), \(point.longitude.cut(.four))"
}

var CURRENT_LOCATION: String {
    return AppGlobals.currentLocation != nil ? CURRENT_GEO_POINT : DEFAULT_GEO_POINT
}
