//
//  Map View.swift
//  BayNav
//
//  Created by Genevieve Ngo on 2/18/25.
//
import SwiftUI
import SwiftData
import Foundation
struct MapView: View {
    @Environment(\.modelContext) private var modelContext
    var body : some View{
        Text ("Map")
    }
}

#Preview {
    MapView()
        .modelContainer(for: Item.self, inMemory: true)
}
