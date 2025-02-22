//
//  consts.swift
//  BayNav
//
//  Created by Genevieve Ngo on 2/16/25.
//

import Foundation

// distance consts. mDist = user is w/i mDist miles of given location for pop up
// convert miles to meters
let  mDist =  1.0 * 1609.34

// Location struct
struct bLocation: Codable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let notes : String
}


//functionally null bloc
let null_bLoc = bLocation(id: 0, name: "", latitude: 0, longitude: 0, notes: "")

// state that when changed updates view, global
class AppState: ObservableObject {
    static let shared = AppState() // Singleton instance

    @Published var selectedDestination: bLocation? = nil
}
