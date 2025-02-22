//
//  Nav View.swift
//  BayNav
//
//  Created by Genevieve Ngo on 2/21/25.
//

import SwiftUI
import SwiftData
import Foundation
struct NavView: View {
    @Environment(\.modelContext) private var modelContext
    var dest: bLocation // Add a property for the destination

    // Initialize the view with the destination
    init(dest: bLocation) {
        self.dest = dest
    }

    var body: some View {
        Text("Nav to \(dest.name)") // Example: Use the destination's name
    }
}

#Preview
{
    NavView(dest: null_bLoc)
        .environmentObject(MockLocationManager())
}
