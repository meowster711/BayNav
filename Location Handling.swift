//
//  Location Handling.swift
//  BayNav
//
//  Created by Genevieve Ngo on 2/16/25.
//

//concerns ... battery life. computing space. 
import UIKit
import Foundation
import CoreLocation
import UserNotifications
import Combine
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var userLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        locationManager.activityType = .automotiveNavigation
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}

class LocationUtils {
    func findClosestBay (userLocation:CLLocation ) -> bLocation{ // takes user location and returns closest bay <= mDist mi else return bLocation with id 0
        // this is O(n) linear search that terminates when found... could be better
        for  bay in bays{
            var bayLocation = CLLocation(latitude: bay.latitude, longitude: bay.longitude)
            if bayLocation.distance(from: userLocation) <= mDist {return bay}
        }
        return null_bLoc
    }
    
}

