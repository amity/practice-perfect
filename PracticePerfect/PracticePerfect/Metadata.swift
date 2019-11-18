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
    var artist: String
    var resourceUrl: String
    var year: Int
    var level: Int
    var topScore: Int // Top possible score
    var highScore: Int // Highest achieved score by any user to date
    var deleted: Bool 
    var rank: String
}

// Data that will be retrieved from the API endpoint
// Need to add more fields - scoring history for info page
struct ScoreMetadata: Hashable, Codable {
    var newScore: Int // Total score
    var pitchPercent: Int // Percent of notes hit in tune
    var tempoPercent: Int // Percent of notes hit on beat
    var perfectPercent: Int // Percent of notes perfect
    var goodPercent: Int // Percent of notes good
    var missPercent: Int // Percent of notes missed
}

struct MusicXMLMetadata: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var url: String
}
