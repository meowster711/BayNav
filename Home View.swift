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
        NavigationStack {
            // Main content
            if let userLocation = locationManager.userLocation {
                MapView(userLocation: .constant(userLocation.coordinate))
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("Error in Locating...")
            }
        }
        // JADEN TO DO
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
        //END JADEN TO DO
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
                if let destination = appState.selectedDestination {
                    NavView(dest: destination)
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
