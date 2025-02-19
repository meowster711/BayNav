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
    // clicking on list item drops down to an expanded details
    // make it prettier ig
    // perhaps more information on this screen?

struct LocationsView: View {
    @Environment(\.modelContext) private var modelContext
    var body : some View{
        List(bays, id: \.id) { bay in Text(bay.name)
        }
    }
}

#Preview
{
    LocationsView()
}
