//
//  Song.swift
//  PracticePerfect
//
//  Created by Sean Hawkins on 11/3/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//

import SwiftUI
import CoreLocation

// Data that will be retrieved from the API endpoint
// Need to add more fields - scoring history for info page
struct SongMetadata: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var highScore: Int
    var rank: String
}

struct MusicXMLMetadata: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var url: String
}

struct CategoryMetadata: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var pieces: [MusicXMLMetadata]
}
