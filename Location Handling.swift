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
        locationManager.requestAlwaysAuthorization() // request "always" location
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        locationManager.activityType = .automotiveNavigation
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true // Allow background updates
    }


    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // triggers whenever location is updated (every 1 sec)
        guard let userLocation = locations.last else { return }
        self.userLocation = userLocation

        //  takes user location and returns closest bay <= mDist mi else return bLocation with id 0
        // this is O(n) linear search that terminates when found. O(n) per 1 sec as default "always" location turned on
            // further implementation: 2mi x 2mi grid in which long & lat are keys to hash table. entries are locations, and then linear search that subset to see if we are w/i 1mi of each location
            // monitor if user leaves 2mix2mi block, so will be O( 1 * subset size) . faster but more overhead .
        
        let dest = null_bLoc // default if no close loc
        for  bay in bays{
            if CLLocation(latitude: bay.latitude, longitude: bay.longitude).distance(from: userLocation) <= mDist {let dest = bay}
        }

        if dest.id != 0 {
            triggerNotification(dest: dest)
        }
    }
}

class MockLocationManager: LocationManager {
    override init() {
        super.init()
        // Set a default location for previews so that there is no crash for debugging
        self.userLocation = CLLocation(latitude: 34.11136, longitude: -118.02725)
    }
}

