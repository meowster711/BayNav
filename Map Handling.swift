//
//  Map Handling.swift
//  BayNav
//
//  Created by Genevieve Ngo on 2/19/25.
//

import Foundation
import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var userLocation: CLLocationCoordinate2D?

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        if let userLocation = userLocation {
            let region = MKCoordinateRegion(
                center: userLocation,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            mapView.setRegion(region, animated: true)
        }
    }
}
