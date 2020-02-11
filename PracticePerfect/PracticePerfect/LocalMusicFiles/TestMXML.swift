//
//  TestMXML.swift
//  PracticePerfect
//
//  Created by Abigail Chen on 2/6/20.
//  Copyright © 2020 CS98PracticePerfect. All rights reserved.
//

import SwiftUI

//Happy Birthday song
//Author: Matty & Mildred J. Hill 1893

//measure 0
let hbdNote1 = NoteMetadata(step: "G", duration: 0.5, type: "eighth", octave: 4)
let hbdNote2 = NoteMetadata(step: "G", duration: 0.5, type: "eighth", octave: 4)
let hbdNote3 = NoteMetadata(step: "A", duration: 1, type: "quarter", octave: 4)
let hbdNote4 = NoteMetadata(step: "G", duration: 1, type: "quarter", octave: 4)

//measure 1
let hbdNote5 = NoteMetadata(step: "C", duration: 1, type: "quarter", octave: 5)
let hbdNote6 = NoteMetadata(step: "B", duration: 2, type: "half", octave: 4)

//measure 2
let hbdNote7 = NoteMetadata(step: "G", duration: 0.5, type: "eighth", octave: 4)
let hbdNote8 = NoteMetadata(step: "G", duration: 0.5, type: "eighth", octave: 4)
let hbdNote9 = NoteMetadata(step: "A", duration: 1, type: "quarter", octave: 4)
let hbdNote10 = NoteMetadata(step: "G", duration: 1, type: "quarter", octave: 4)

//measure 3
let hbdNote11 = NoteMetadata(step: "D", duration: 1, type: "quarter", octave: 5)
let hbdNote12 = NoteMetadata(step: "C", duration: 2, type: "half", octave: 5)

//measure 4
let hbdNote13 = NoteMetadata(step: "G", duration: 0.5, type: "eighth", octave: 4)
let hbdNote14 = NoteMetadata(step: "G", duration: 0.5, type: "eighth", octave: 4)
let hbdNote15 = NoteMetadata(step: "G", duration: 1, type: "quarter", octave: 5)
let hbdNote16 = NoteMetadata(step: "E", duration: 1, type: "quarter", octave: 5)

//measure 5
let hbdNote17 = NoteMetadata(step: "C", duration: 1, type: "quarter", octave: 5)
let hbdNote18 = NoteMetadata(step: "B", duration: 1, type: "quarter", octave: 4)
let hbdNote19 = NoteMetadata(step: "A", duration: 1, type: "quarter", octave: 4)

//measure 6
let hbdNote20 = NoteMetadata(step: "F", duration: 0.5, type: "eighth", octave: 5)
let hbdNote21 = NoteMetadata(step: "F", duration: 0.5, type: "eighth", octave: 5)
let hbdNote22 = NoteMetadata(step: "E", duration: 1, type: "quarter", octave: 5)
let hbdNote23 = NoteMetadata(step: "C", duration: 1, type: "quarter", octave: 5)

//measure 7
let hbdNote24 = NoteMetadata(step: "D", duration: 1, type: "quarter", octave: 5)
let hbdNote25 = NoteMetadata(step: "C", duration: 2, type: "half", octave: 5)

var hbdTestMeasures : Array<MeasureMetadata> = [
    MeasureMetadata(measureNumber: 0, notes: [hbdRest1, hbdRest2, hbdRest3], clef: "G", fifths: 0, mode: "major"),
    MeasureMetadata(measureNumber: 1, notes: [hbdNote1, hbdNote2, hbdNote3, hbdNote4], clef: "G", fifths: 0, mode: "major"),
    MeasureMetadata(measureNumber: 2, notes: [hbdNote5, hbdNote6], clef: "G", fifths: 0, mode: "major"),
    MeasureMetadata(measureNumber: 3, notes: [hbdNote7, hbdNote8, hbdNote9, hbdNote10], clef: "G", fifths: 0, mode: "major"),
    MeasureMetadata(measureNumber: 4, notes: [hbdNote11, hbdNote12], clef: "G", fifths: 0, mode: "major"),
    MeasureMetadata(measureNumber: 5, notes: [hbdNote13, hbdNote14, hbdNote15, hbdNote16], clef: "G", fifths: 0, mode: "major"),
    MeasureMetadata(measureNumber: 6, notes: [hbdNote17, hbdNote18, hbdNote19], clef: "G", fifths: 0, mode: "major"),
    MeasureMetadata(measureNumber: 7, notes: [hbdNote20, hbdNote21, hbdNote22, hbdNote23], clef: "G", fifths: 0, mode: "major"),
    MeasureMetadata(measureNumber: 8, notes: [hbdNote24, hbdNote25], clef: "G", fifths: 0, mode: "major")]

let hbdRest1 = NoteMetadata(duration: 1, type: "quarter", isRest: true)
let hbdRest2 = NoteMetadata(duration: 1, type: "quarter", isRest: true)
let hbdRest3 = NoteMetadata(duration: 1, type: "quarter", isRest: true)

struct TestMXML: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct TestMXML_Previews: PreviewProvider {
    static var previews: some View {
        TestMXML()
    }
}
