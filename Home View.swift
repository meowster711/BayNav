//
//  HomeView.swift
//  BayNav
//
//  Created by Genevieve Ngo on 2/16/25.
//

import SwiftUI
import MapKit

struct HomeView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var appState: AppState

    var body: some View {
        // Extract userLocation outside of NavigationStack
        let userLocation = locationManager.userLocation

        NavigationStack {
            // Main content
            if let userLocation = userLocation {
                MapView(userLocation: .constant(userLocation.coordinate))
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("Error in Locating...")
            }
        }
        .navigationTitle("BayNav")
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                NavigationLink(destination: LocationsView()) {
                    Image(systemName: "flag")
                        .foregroundColor(.black)
                }
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gear")
                        .foregroundColor(.black)
                }
            }
        }
        .navigationDestination(
            isPresented: Binding<Bool>(
                get: { appState.selectedDestination != nil },
                set: { newValue in
                    if !newValue {
                        appState.selectedDestination = nil // Reset the state
                    }
                }
            ),
            destination: {
                if let destination = appState.selectedDestination,
                   let userLocation = userLocation { // Ensure userLocation is available
                    NavView(destination: destination)
                }
            }
        )
    }
}


#Preview {
    NavigationStack {
           HomeView()
               .environmentObject(MockLocationManager() as LocationManager)
               .environmentObject(AppState()) 

       }
}
