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
struct SongMetadata: Identifiable, Hashable, Codable {
    var id = UUID()
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

struct ScaleMetadata: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var urls: [String]
}

class NoteMetadata: Identifiable {
    var id = UUID()
    //later will expand from Perfect/Miss to Perfect/Close/Miss, etc.
    var isRightNote: Bool = false
    
    var measureNumber: Int = 0
    var noteNumber: Int = 0
    
    var isRest: Bool = false //if true then step, octave, type are blank
    
    //pitch
    var step: String = "" //C, D, E, etc.
    //var alter: Int? //Going to need to ask about this; example value: -1
    var octave: Int = 0 //Usually 2, 3, 4, or 5 for G Clef; an octave starts on C
    
    var duration: Float = 0 //Usually 1 per quarter note but it depends on the file
    //<voice> tag currently ignored so we can only support one pitch/hand/instrument at a time
    var noteType: String = "" //quarter, half, whole, eight, etc.
    
    var position: Int = 0 //if same position as last note, it's a chord
    
}

class MeasureMetadata {
    var id = UUID()
    var measureNumber: Int = 0
    var notes: Array<NoteMetadata> = []
}

