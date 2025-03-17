//
//  Location View.swift
//  BayNav
//
//  Created by Genevieve Ngo on 2/17/25.
//
import SwiftUI
import SwiftData
import Foundation

// TODO :
    // make it prettier ig
    // perhaps more information on this screen?
    // option to NAV DIRECTLY from clicking the bay

struct LocationsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var expandedBayId: Int? = nil // Track which bay is expanded

    var body: some View {
        List(bays, id: \.id) { bay in
            VStack(alignment: .leading, spacing: 8) {
                // Bay Name and Chevron
                HStack {
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(expandedBayId == bay.id ? 90 : 0)) // Rotate when expanded
                        .animation(.easeInOut, value: expandedBayId) // Animate the rotation
                    
                    Text(bay.name)
                        .font(.headline)
                        .bold()
                    
                }

                // Additional Details (visible only when expanded)
                if expandedBayId == bay.id {
                    VStack(alignment: .leading, spacing: 8) {

                        Text("Notes")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(bay.notes)
                    }
                    .transition(.opacity) // Smooth fade-in animation
                }
            }
            .padding(.vertical, 8)
            .onTapGesture {
                withAnimation(.easeInOut) {
                    // Toggle expanded state
                    if expandedBayId == bay.id {
                        expandedBayId = nil // Collapse if already expanded
                    } else {
                        expandedBayId = bay.id // Expand if collapsed
                    }
                }
            }
        }
    }
}

#Preview
{
    LocationsView()
        .environmentObject(MockLocationManager())
}
