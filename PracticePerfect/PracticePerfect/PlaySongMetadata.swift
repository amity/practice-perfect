//
//  PlaySongMetadata.swift
//  PracticePerfect
//
//  Created by Abigail Chen on 11/9/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//

import SwiftUI

class PlaySongMetadata {
    
    var songNumber: Int = 0 //Related to database
    var title: String = "untitled"
    var composer: String = "unlisted"
    var parts: [String:String] = [:] //ex: "P1" : Voice; needs to only display 1 part at a time, and different parts should become different songs to play

    var divisions: Int = 0 //Determines duration of notes, like 24
    var key: [Int:String] = [:] //ex: -3 <fifths>, minor <mode> corresponds to 3 flats, C minor
    var timeSignature: [Int:Int]=[:] //ex: 3 <beats>, 4 <beat-type>
    var clef: [String:Int] = [:] //ex: G <sign>, 2 <line>

    var numMeasures: Int = 0
    var measures: Array<MeasureMetadata> = []

}
