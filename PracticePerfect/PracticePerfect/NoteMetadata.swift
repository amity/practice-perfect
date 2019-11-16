//
//  NoteMetadata.swift
//  PracticePerfect
//
//  Created by Abigail Chen on 11/9/19.
//  Copyright © 2019 AbigailChen. All rights reserved.
//

import SwiftUI

class NoteMetadata {
    
    //later will expand from Perfect/Miss to Perfect/Close/Miss, etc.
    var isRightNote = false
    
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
