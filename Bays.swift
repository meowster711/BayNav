//
//  Bays.swift
//  BayNav
//
//  Created by Genevieve Ngo on 2/16/25.
//

import Foundation

// Location struct
struct bLocation: Codable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let notes : String
}


// database of bays for now
let bays: [bLocation] = [
    bLocation(id: 1, name: "Kaiser South Bay", latitude: 33.79032, longitude: 118.29548, notes : "Sheets are near the entrance"),
    bLocation(id: 2, name: "Kaiser Downey", latitude: 33.92068, longitude: 118.12965, notes : "Sheets are on your left from the EMS entrance"),
    bLocation(id: 3, name: "Kaiser Sunset", latitude: 34.09896, longitude:118.29395, notes : ""),
    bLocation(id: 4, name: "Kaiser West LA", latitude: 34.03804, longitude: 118.37535, notes : ""),

]

