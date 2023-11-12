//
//  LocationManager.swift
//  CompassSender
//
//  Created by Ian Christie on 9/24/23.
//

import CoreLocation
import UIKit

class LocationManger: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocation?
    static let shared = LocationManger()
    
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyReduced
        manager.allowsBackgroundLocationUpdates = true
        manager.showsBackgroundLocationIndicator = true
        manager.pausesLocationUpdatesAutomatically = false
        manager.startUpdatingLocation()
    }
    
    func requestLocation() {
        manager.requestAlwaysAuthorization()
    }
}

extension LocationManger: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
    
        case .notDetermined:
            print("DEBUG: not determined")
        case .restricted:
            print("DEBUG: restricted")
        case .denied:
            print("DEBUG: denied")
        case .authorizedAlways:
            manager.startUpdatingLocation()
            manager.startMonitoringSignificantLocationChanges()
            print("DEBUG: auth always")
        case .authorizedWhenInUse:
            print("DEBUG: auth when in use")
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("Location: \(location)")
        self.userLocation = location
        let numberFormatter = NumberFormatter()
        let latitude = numberFormatter.number(from: location.coordinate.latitude.formatted())!.doubleValue
        let longitude = numberFormatter.number(from: location.coordinate.longitude.formatted())!.doubleValue

        let locationToSend = Location(latitude: latitude, longitude: longitude)
        LocationAPI().setServerLocation(location: locationToSend, update_type: "automatic")
        
        if (Global.shared.launchedFromLocation == true) {
            exit(0)
        }
    }
}
