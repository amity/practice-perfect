//
//  ParseMusicXML.swift
//  PracticePerfect
//
//  Created by Abigail Chen on 11/9/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//
//SWXMLHash docs and refs:
//https://github.com/drmohundro/SWXMLHash
//http://cocoadocs.org/docsets/SWXMLHash/4.2.2/
//https://leaks.wanari.com/2016/08/24/xml-parsing-swift/

import SwiftUI
import SWXMLHash

//Currently loads local file to String
func loadXML2String(fileName : String, fileExtension: String) -> String {
    if let filepath = Bundle.main.path(forResource: fileName, ofType: fileExtension) {
        do {
            let contents = try String(contentsOfFile: filepath)
//            print(contents)
            return(contents)
        } catch {
            return "file contents could not be loaded"
        }
    } else {
        return "file not found"
    }
}

//***TEMPORARILY HOT CODED TO LOCAL TEST FILES***
//var musicXMLToParseFromFile: String = loadXML2String(fileName: "apres", fileExtension: "musicxml")
//var musicXMLToParseFromFile: String = loadXML2String(fileName: "C_Major_Scale", fileExtension: "musicxml")

//var musicXMLToParseFromFile: String = loadXML2String(fileName: "Happy_Birthday_To_You", fileExtension: "mxl")

var musicXMLToParseFromFile: String = loadXML2String(fileName: "Pokemon_Center", fileExtension: "mxl")

//Some kind of glitch on Measure 18
//var musicXMLToParseFromFile: String = loadXML2String(fileName: "Jingle_Bells", fileExtension: "mxl")

//var musicXMLToParseFromFile: String = loadXML2String(fileName: "My_Way", fileExtension: "mxl")

//var musicXMLToParseFromFile: String = loadXML2String(fileName: "Game_Of_Thrones_Opening_Theme", fileExtension: "mxl")

//var musicXMLToParseFromFile: String = loadXML2String(fileName: "Viva_La_Vida", fileExtension: "mxl")


//initialize SWXMLHash object
//temporarily hotcoded to apres test file
var xml = SWXMLHash.config {
            config in
            config.shouldProcessLazily = false
}.parse(musicXMLToParseFromFile)


func parseNoteMusicXML(measureNumber : Int, noteNumber : Int) -> NoteMetadata {
    let noteToParse : NoteMetadata = NoteMetadata()
    
    noteToParse.measureNumber = measureNumber
    
    //temporary conversion for duration parsing, assuming quarter note is a duration of 1.0
    let duration = Float( xml["score-partwise"]["part"][0]["measure"][measureNumber-1]["note"][noteNumber-1]["duration"].element!.text ) ?? 0
    let divisions = Int( xml["score-partwise"]["part"][0]["measure"][0]["attributes"]["divisions"].element!.text ) ?? 24
    
    noteToParse.duration = duration / Float(divisions)
    
    if noteToParse.duration == 3 || noteToParse.duration == 1.5 || noteToParse.duration == 6 || noteToParse.duration == 0.75 || noteToParse.duration == 0.375 {
        noteToParse.dot = true
    }
    
    //<voice> tag currently ignored so we can only support one pitch/hand/instrument at a time
    
    //if rest and not note, set isRest to true and set type based on duration
    if ( xml["score-partwise"]["part"][0]["measure"][measureNumber-1]["note"][noteNumber-1].children[0].element!.name == "rest" ) {
            noteToParse.isRest = true
        
        //numBeats = noteToParse.duration / songToParse.divisions
        //if numBeats == 1 then "quarter"
        //if numBeats == 2 then "half"
        //if numBeats == 0.5 then "eighth"
        //if numBeats == 0.25 then "sixteenth"
        //if numBeats == 0.125 then etc.
        }
    
    //if note and not rest, set step, octave, type, position
    if !noteToParse.isRest {
        noteToParse.step = xml["score-partwise"]["part"][0]["measure"][measureNumber-1]["note"][noteNumber-1]["pitch"]["step"].element!.text
    
        //noteToParse.alter might be coming in future

        noteToParse.octave = Int( xml["score-partwise"]["part"][0]["measure"][measureNumber-1]["note"][noteNumber-1]["pitch"]["octave"].element!.text ) ?? 0

        noteToParse.type = xml["score-partwise"]["part"][0]["measure"][measureNumber-1]["note"][noteNumber-1]["type"].element!.text
    
        //if position matches previous note's position then it is a chord
        //not currently used
        noteToParse.position = Int( xml["score-partwise"]["part"][0]["measure"][measureNumber-1]["note"][noteNumber-1].element!.attribute(by: "default-x")!.text ) ?? 0
    }
    
    return noteToParse
}


func parseMeasureMusicXML(measureNumber : Int) -> MeasureMetadata {
    let measureToParse : MeasureMetadata = MeasureMetadata()
    
    measureToParse.measureNumber = measureNumber
    
    measureToParse.fifths = parseKeySignatureFifths()
    
    measureToParse.timeSig = (parseTimeSignatureBeats(), parseTimeSignatureBeatType() )
    
    //only counts right hand notes, assumes no rests in left hand part
    let numAllNotes = xml["score-partwise"]["part"][0]["measure"][measureNumber-1]["note"].all.count
   
    var numNotesWithRests = 0 //total number of right hand notes including rests for display
    var numNotesNoRests = 0 //total number of right hand notes and no rests for score calculation
    
    //write a version for plain parsing
    
    //handles cases with 2 hands that has default-y
    //checks if staff = 1
    for index in 0..<numAllNotes { //handles case if 2 hands
        if xml["score-partwise"]["part"][0]["measure"][measureNumber-1]["note"][index]["staff"].element == nil { //handles non 2-handed pieces
            numNotesWithRests += 1
            numNotesNoRests += 1
        }
        else if Int(xml["score-partwise"]["part"][0]["measure"][measureNumber-1]["note"][index]["staff"].element!.text)! == 1 { //handles 2-handed pieces
            if xml["score-partwise"]["part"][0]["measure"][measureNumber-1]["note"][index].element!.attribute(by: "default-y") == nil {
                numNotesWithRests += 1 //note is a rest
            }
            else { //note is not a rest
                if Int(Double(xml["score-partwise"]["part"][0]["measure"][measureNumber-1]["note"][index].element!.attribute(by: "default-y")!.text)!) > Int(-90) {
                    numNotesWithRests += 1 //note is right hand
                    numNotesNoRests += 1
                }
            }
        }
        else { //if reached staff 2 then quit adding notes
            break
        }
    }
    
    measureToParse.numNotes = numNotesWithRests
    measureToParse.numNotesNoRests = numNotesNoRests
    
    //create array of NoteMetadatas by noteNumber
    //currently doesn't handle multiple parts
    for index in 1...measureToParse.numNotes {
        measureToParse.notes.append( parseNoteMusicXML(measureNumber: measureNumber, noteNumber: index))
        
    }
    
    return measureToParse
}


//parsing to create SongMetadata object that contains MeasureMetadata objects that contain NoteMetadata objects
//CURRENTLY HOTCODED FOR PART 1 ONLY
func parseMusicXML(isSong: Bool, xmlString: String) -> PlaySongMetadata {
    // Get xml from xml string
    xml = SWXMLHash.config {
                config in
                config.shouldProcessLazily = false
    }.parse(xmlString)
    
    //create metadata object
    let songToParse : PlaySongMetadata = PlaySongMetadata()
    
    //isRightNote to be used in Play Mode
    //later will expand from Perfect/Miss to Perfect/Close/Miss, etc.
        
    //noteNumber, measureNumber initailized when created in measure's array of NoteMetadata
        
    //***TEMPORARY HOT CODED SONG NUMBER*** -> WILL PULL FROM API
    songToParse.songNumber = 0
    
    songToParse.title  = (xml["score-partwise"]["movement-title"].element != nil) ? xml["score-partwise"]["movement-title"].element!.text : "untitled"
        
        // ?? "untitled"
        
    songToParse.composer = (xml["score-partwise"]["identification"]["creator"].element != nil) ? xml["score-partwise"]["identification"]["creator"].element!.text : "unlisted"
    
    for index in 0..<xml["score-partwise"]["part-list"]["score-part"].all.count {
        songToParse.parts[xml["score-partwise"]["part-list"]["score-part"][index].element!.attribute(by: "id")!.text] = xml["score-partwise"]["part-list"]["score-part"][index]["part-name"].element!.text
    }
    
    songToParse.divisions = (xml["score-partwise"]["part"][0]["measure"][0]["attributes"]["divisions"].element != nil) ? Int(xml["score-partwise"]["part"][0]["measure"][0]["attributes"]["divisions"].element!.text)! : 24 //24 default value hotcoded because it's the most common note divisions number in files I've seen, probably because it's divisible by 2, 3, 4, 6, 8, and 12 for durations
      
    songToParse.key = [ parseKeySignatureFifths() : parseKeySignatureMode() ]
    //0 and "major" are default values which is C major, no sharps or flats
      
    songToParse.timeSignature = [ parseTimeSignatureBeats() : parseTimeSignatureBeatType() ]
    
    //currently handles first clef (usually right hand melody)
    songToParse.clef = [ xml["score-partwise"]["part"][0]["measure"][0]["attributes"]["clef"][0]["sign"].element!.text : Int(xml["score-partwise"]["part"][0]["measure"][0]["attributes"]["clef"][0]["line"].element!.text) ?? 2]
      
    songToParse.numMeasures = xml["score-partwise"]["part"][0]["measure"].all.count
    
    //create array of MeasureMetadatas by measureNumber
    //currently doesn't handle multiple parts
    for index in 1...songToParse.numMeasures {
        songToParse.measures.append( parseMeasureMusicXML(measureNumber: index) )
    }
    
    songToParse.measures = [createStartingRests()] + songToParse.measures
    
    var numNotesWithRests = 0
    for measure in songToParse.measures {
        numNotesWithRests += measure.numNotes
    }
    songToParse.numNotesWithRests = numNotesWithRests
    
    var numNotesWithoutRests = 0
    for measure in songToParse.measures {
        numNotesWithoutRests += measure.numNotesNoRests
    }
    songToParse.numNotesWithoutRests = numNotesWithoutRests
    
    return songToParse
}


func parseTimeSignatureBeats() -> Int {
    return Int (xml["score-partwise"]["part"][0]["measure"][0]["attributes"]["time"]["beats"].element!.text ) ?? 4
}

func parseTimeSignatureBeatType() -> Int {
    return Int( xml["score-partwise"]["part"][0]["measure"][0]["attributes"]["time"]["beat-type"].element!.text ) ?? 4
}

func parseKeySignatureFifths() -> Int {
    return Int(xml["score-partwise"]["part"][0]["measure"][0]["attributes"]["key"]["fifths"].element!.text) ?? 0
    //0 and "major" are default values which is C major, no sharps or flats
}

func parseKeySignatureMode() -> String {
//    if xml["score-partwise"]["part"][0]["measure"][0]["attributes"]["key"]["mode"].element!.text != nil {
//        return xml["score-partwise"]["part"][0]["measure"][0]["attributes"]["key"]["mode"].element!.text
//    }
//    else {
        if parseKeySignatureFifths() >= 0 {
            return "major"
        }
        else {
            return "minor"
        }
    //}
}

func createStartingRests() -> MeasureMetadata {
    let restMeasure = MeasureMetadata(measureNumber: 0, notes: [], clef: "G", fifths: parseKeySignatureFifths(), mode: "major", timeSig: (parseTimeSignatureBeats(), parseTimeSignatureBeatType()))
    
    for _ in 0..<parseTimeSignatureBeats() {
        if parseTimeSignatureBeatType() == 4 {
            restMeasure.notes.append( NoteMetadata(duration: 1, type: "quarter", isRest: true) )
        }
        else if parseTimeSignatureBeatType() == 2 {
            restMeasure.notes.append( NoteMetadata(duration: 2, type: "half", isRest: true) )
        }
        else if parseTimeSignatureBeatType() == 8 {
            restMeasure.notes.append( NoteMetadata(duration: 0.5, type: "eighth", isRest: true) )
        }
        else if parseTimeSignatureBeatType() == 16 {
            restMeasure.notes.append( NoteMetadata(duration: 0.25, type: "16th", isRest: true) )
        }
        else { //all other cases just put quarter notes for now
            restMeasure.notes.append( NoteMetadata(duration: 1, type: "quarter", isRest: true) )
        }
    }
    
    return restMeasure
}

//used for displaying songs
func getNumNotesWithRests(songToParse: PlaySongMetadata) -> Int {
    var numNotesWithRests = 0
    for measure in songToParse.measures {
        numNotesWithRests += measure.numNotes
    }
    return numNotesWithRests
}

//used for score calculation
func getNumNotesWithoutRests(songToParse: PlaySongMetadata) -> Int {
    var numNotesWithoutRests = 0
    for measure in songToParse.measures {
        numNotesWithoutRests += measure.numNotesNoRests
    }
    return numNotesWithoutRests
}


struct ParseMusicXML: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ParseMusicXML_Previews: PreviewProvider {
    static var previews: some View {
        ParseMusicXML()
    }
}
