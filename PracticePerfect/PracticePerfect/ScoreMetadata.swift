//
//  ScoreMetadata.swift
//  PracticePerfect
//
//  Created by Sean Hawkins on 11/12/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//

import SwiftUI

// Data that will be retrieved from the API endpoint
// Need to add more fields - scoring history for info page
struct ScoreMetadata: Hashable, Codable {
    var overallRank: String
    var pitchRank: String
    var tempoRank: String
    var newScore: Int
    var scorePercent: Int
    var perfectCount: Int
    var goodCount: Int
    var missCount: Int
}
