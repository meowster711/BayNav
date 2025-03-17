//
//  Map Step View View.swift
//  BayNav
//
//  Created by Genevieve Ngo on 2/26/25.
//

import SwiftUI
import MapKit
// Full-Screen Map View with Driving Style
struct MapViewForStep: UIViewRepresentable {
    var steps: [MKRoute.Step]
    var currentStepIndex: Int
    var userLocation: CLLocation?

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        // Configure the map for driving view
        mapView.userTrackingMode = .followWithHeading // Follow the user's location and heading
        mapView.showsUserLocation = true // Show the user's location
        mapView.isZoomEnabled = true // Allow zooming
        mapView.isScrollEnabled = true // Allow scrolling
        mapView.isRotateEnabled = true // Allow rotation
        mapView.isPitchEnabled = true // Allow 3D tilt

        // Set the map to a 3D perspective
        let camera = MKMapCamera()
        camera.centerCoordinate = userLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
        camera.pitch = 45 // Tilt the map (0 = flat, 90 = fully vertical)
        camera.altitude = 500 // Height of the camera above the ground (in meters)
        camera.heading = userLocation?.course ?? 0 // Use the user's heading (direction they're facing)
        mapView.camera = camera

        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        // Remove existing overlays (e.g., previous polylines)
        mapView.removeOverlays(mapView.overlays)

        // Add the polyline for the entire route
        if !steps.isEmpty {
            // Combine all step polylines into one
            var coordinates: [CLLocationCoordinate2D] = []
            for step in steps {
                let stepCoordinates = step.polyline.coordinates
                coordinates.append(contentsOf: stepCoordinates)
            }

            let routePolyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            mapView.addOverlay(routePolyline)
        }

        // Adjust the map's visible region to fit the entire route
        if !steps.isEmpty {
            let routeRect = steps.reduce(MKMapRect.null) { $0.union($1.polyline.boundingMapRect) }
            let padding = UIEdgeInsets(top: 50, left: 50, bottom: 150, right: 50)
            mapView.setVisibleMapRect(routeRect, edgePadding: padding, animated: true)
        }

        // Update the camera to follow the user's location and heading
        if let userLocation = userLocation {
            let camera = MKMapCamera()
            camera.centerCoordinate = userLocation.coordinate
            camera.pitch = 45 // Tilt the map
            camera.altitude = 500 // Height of the camera
            camera.heading = userLocation.course // Use the user's heading
            mapView.camera = camera
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            // polyline settings TODO JADEN
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 18
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}

// Helper function to extract coordinates from MKPolyline
extension MKPolyline {
    var coordinates: [CLLocationCoordinate2D] {
        var coords: [CLLocationCoordinate2D] = Array(repeating: kCLLocationCoordinate2DInvalid, count: pointCount)
        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
        return coords
    }
}
