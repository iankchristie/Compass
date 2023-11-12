//
//  ContentViewModel.swift
//  CompassReceiver
//
//  Created by Ian Christie on 11/9/23.
//

import Foundation
import CoreLocation

struct CompassViewModel {
    var deviceLocation: Location = Location(latitude: 0, longitude: 0)
    var serverLocation: Location = Location(latitude: 0, longitude: 0)
    var coordinateHeading: CLLocationDirection = 0.0
    var bearing: Double = 0.0
}


