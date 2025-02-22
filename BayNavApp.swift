//
//  BayNavApp.swift
//  BayNav
//
//  Created by Genevieve Ngo on 2/16/25.
//

import SwiftUI
import SwiftData

@main
struct BayNavApp: App {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var appState = AppState.shared

        var body: some Scene {
            WindowGroup {
                NavigationStack {
                    HomeView()
                        .environmentObject(LocationManager())
                        .environmentObject(appState)
                }
            }
        }
    }
