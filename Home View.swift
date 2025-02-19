//
//  HomeView.swift
//  BayNav
//
//  Created by Genevieve Ngo on 2/16/25.
//

import SwiftUI
import SwiftData
import MapKit

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    
    
    var body: some View {
        NavigationStack {
            Text ("Map") //TODO: use MKMap
                .navigationTitle("BayNav")
                .toolbar { // TODO : jaden pls make look pretty
                    ToolbarItemGroup(placement: .bottomBar) { NavigationLink(destination: LocationsView())
                        {Image(systemName: "flag").foregroundColor(.black) }
                        NavigationLink(destination: SettingsView())
                            { Image(systemName: "gear").foregroundColor(.black) }
                    }
                }
        }
    }
}



#Preview {
    HomeView()
}
