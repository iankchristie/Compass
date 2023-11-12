//
//  ContentViewModelPublisher.swift
//  CompassReceiver
//
//  Created by Ian Christie on 11/10/23.
//

import Foundation
import Combine

class CompassViewModelPublisher {
    static let shared = CompassViewModelPublisher()

    var state = Publishers.CombineLatest3(
        LocationManger.shared.locationSubject,
        LocationManger.shared.headingSubject,
        LocationService.shared.serverLocationPublisher.receive(on: RunLoop.main)
    )
        .map { deviceLocation, heading, serverLocation in
            return CompassViewModel(
                deviceLocation: Location(latitude: deviceLocation.coordinate.latitude, longitude: deviceLocation.coordinate.longitude),
                serverLocation: serverLocation,
                coordinateHeading: heading,
                bearing: LocationUtils.shared.getBearing(
                    latitude1: deviceLocation.coordinate.latitude,
                    longitude1: deviceLocation.coordinate.longitude,
                    latitude2: serverLocation.latitude,
                    longitude2: serverLocation.longitude
                )
            )
        }
        .replaceError(with: CompassViewModel())
}
