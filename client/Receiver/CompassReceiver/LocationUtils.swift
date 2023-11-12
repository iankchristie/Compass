//
//  LocationUtils.swift
//  CompassReceiver
//
//  Created by Ian Christie on 10/4/23.
//

import Foundation

class LocationUtils {
    static let shared = LocationUtils()
    private init() { }

    func getBearing(latitude1: Double, longitude1: Double, latitude2: Double, longitude2: Double) -> Double {
        let deltaL = longitude2.toRadians - longitude1.toRadians
        let thetaB = latitude2.toRadians
        let thetaA = latitude1.toRadians
        let x = cos(thetaB) * sin(deltaL)
        let y = cos(thetaA) * sin(thetaB) - sin(thetaA) * cos(thetaB) * cos(deltaL)
        let bearing = atan2(x,y)
        let bearingInDegrees = bearing.toDegrees
        return bearingInDegrees
    }
}

extension Double {
    var toRadians : Double {
        return Measurement(value: self, unit: UnitAngle.degrees).converted(to: .radians).value
    }
    var toDegrees : Double {
        return Measurement(value: self, unit: UnitAngle.radians).converted(to: .degrees).value
    }
}
