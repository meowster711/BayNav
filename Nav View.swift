//
//  Nav View.swift
//  BayNav
//
//  Created by Genevieve Ngo on 2/21/25.
//

import SwiftUI
import MapKit

struct NavView: View {
    var destination: bLocation

    @EnvironmentObject var locationManager: LocationManager
    @State private var steps: [MKRoute.Step] = []
    @State private var currentStepIndex: Int = 0
    @State private var endNavBox: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                // Full-Screen Map View
                MapViewForStep(
                    steps: steps,
                    currentStepIndex: currentStepIndex,
                    userLocation: locationManager.userLocation
                )
                .edgesIgnoringSafeArea(.all)
                
                // Floating Directions Box at the top
                if !endNavBox{
                    VStack {
                        if !steps.isEmpty && currentStepIndex < steps.count{
                            let currentStep = steps[currentStepIndex]
                            VStack(alignment: .leading, spacing: 10) { // Add spacing between text elements
                                Text("Next: \(currentStep.instructions)")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.black)
                                Text("Distance: \(formattedDistance(currentStep.distance))")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                            .padding(20)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding(.top, 44) // Adjust for safe area
                        } else {
                            
                            VStack(alignment: .leading, spacing: 10) { // Add spacing between text elements
                                Text("Arrived at" + destination.name)
                            }
                            .padding(20)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding(.top, 44) // Adjust for safe area
                        }
                        Spacer() // Push the directions box to the top
                    }
                    
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // Align to top
                }
                
                // End Navigation Button at the bottom
                if !endNavBox {
                    VStack {
                        Spacer()
                        Button(action: {
                            endNavigation()
                            endNavBox = true
                        }) {
                            Text("End Navigation")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .bold()
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 44) // Adjust this value to account for the safe area
                    }
                }
                if endNavBox {
                    VStack {
                        Spacer()
                        VStack {
                            HStack{
                                Text("Navigation Ended")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Spacer ()
                                // possibly need to fix
                                NavigationLink(destination: HomeView()) {Image(systemName: "house")
                                    .foregroundColor(.black)}
                            }

                            Text("\nNotes:")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.black)
                            Text (destination.notes)
                                .font(.system(size: 15))
                                .foregroundColor(.black)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                        .padding(.bottom, 100) // Adjust distance from the bottom
                        .transition(.move(edge: .bottom)) // Slide up from the bottom
                    }
                }
            }
        }
        .onAppear {
            calculateDirections()
        }
        .onChange(of: locationManager.userLocation) { newLocation in
            if let newLocation = newLocation {
                updateCurrentStep(userLocation: newLocation)
            }
        }
        
        
    }

    private func calculateDirections() {
        guard let userLocation = locationManager.userLocation else { return }
        
        let sourcePlacemark = MKPlacemark(coordinate: userLocation.coordinate)
        let destinationPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: destination.latitude, longitude: destination.longitude))
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionsRequest = MKDirections.Request()
        directionsRequest.source = sourceMapItem
        directionsRequest.destination = destinationMapItem
        directionsRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionsRequest)
        directions.calculate { response, error in
            guard let route = response?.routes.first else {
                print("Error calculating directions: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            steps = route.steps
            
            // Skip the first step if it has no instructions or distance
            if !steps.isEmpty && (steps[0].instructions.isEmpty || steps[0].distance == 0) {
                steps.removeFirst()
            }
            
            // Reset the currentStepIndex if steps were modified
            currentStepIndex = 0
            
            print("Steps: \(steps)") // Debugging: Print the steps array
            for (index, step) in steps.enumerated() {
                print("Step \(index): \(step.instructions) - \(step.distance) meters")
                
            }
        }
       
    }

    private func endNavigation() {
        steps = []
        currentStepIndex = 0
        endNavBox = true
        
    }

    private func updateCurrentStep(userLocation: CLLocation) {
        guard !steps.isEmpty else { return }

        // Check if the user has reached the current step
        let currentStep = steps[currentStepIndex]
        let stepLocation = CLLocation(latitude: currentStep.polyline.coordinate.latitude, longitude: currentStep.polyline.coordinate.longitude)
        let distanceToStep = userLocation.distance(from: stepLocation)

        print("Current Step Index: \(currentStepIndex), Distance to Step: \(distanceToStep) meters") // Debugging

        if distanceToStep < 50 { // Threshold for reaching the step (50 meters)
            if currentStepIndex < steps.count - 1 {
                currentStepIndex += 1 // Move to the next step
                print("Moved to Step \(currentStepIndex)") // Debugging
            } else {
                endNavigation() // End of route
            }
        }
    }

    private func formattedDistance(_ distance: CLLocationDistance) -> String {
        let formatter = MKDistanceFormatter()
        formatter.units = .metric
        return formatter.string(fromDistance: distance)
    }
}
    

    #Preview
    {
        
        NavView(destination: bays[0])
            .environmentObject(MockLocationManager() as LocationManager)
        
    }

    

