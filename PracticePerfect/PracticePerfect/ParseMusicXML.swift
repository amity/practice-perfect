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
            print(contents)
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
//var musicXMLToParseFromFile: String = loadXML2String(fileName: "Happy_Birthday_To_You_C_Major", fileExtension: "mxl")
//var musicXMLToParseFromFile: String = loadXML2String(fileName: "Pokemon_Center", fileExtension: "mxl") -> replace with new file
var musicXMLToParseFromFile: String = loadXML2String(fileName: "Happy_Birthday", fileExtension: "mxl")


//initialize SWXMLHash object
//temporarily hotcoded to apres test file
let xml = SWXMLHash.config {
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
    
    //noteToParse.duration = Float( xml["score-partwise"]["part"][0]["measure"][measureNumber-1]["note"][noteNumber-1]["duration"].element!.text ) ?? 0
    
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
    
    //only counts right hand notes, assumes no rests in left hand part
    let numAllNotes = xml["score-partwise"]["part"][0]["measure"][measureNumber-1]["note"].all.count
   
    var numSelectNotes = 0
    
    //write a version for plain parsing
    
    //handles cases with 2 hands that has default-y
    //checks if staff = 1
    for index in 0..<numAllNotes {
        if xml["score-partwise"]["part"][0]["measure"][measureNumber-1]["note"][index]["staff"].element == nil { //handles non 2-handed pieces
            numSelectNotes += 1
        }
        else if Int(xml["score-partwise"]["part"][0]["measure"][measureNumber-1]["note"][index]["staff"].element!.text)! == 1 { //handles 2-handed pieces
            if xml["score-partwise"]["part"][0]["measure"][measureNumber-1]["note"][index].element!.attribute(by: "default-y") == nil {
                numSelectNotes += 1 //note is a rest
            }
            else { //note is not a rest
                if Int(Double(xml["score-partwise"]["part"][0]["measure"][measureNumber-1]["note"][index].element!.attribute(by: "default-y")!.text)!) > Int(-90) {
                    numSelectNotes += 1 //note is right hand
                }
            }
        }
        else { //if reached staff 2 then quit adding notes
            break
        }
    }
    
    measureToParse.numNotes = numSelectNotes
    
    //create array of NoteMetadatas by noteNumber
    //currently doesn't handle multiple parts
    for index in 1...measureToParse.numNotes {
        measureToParse.notes.append( parseNoteMusicXML(measureNumber: measureNumber, noteNumber: index))
        
    }
    
    return measureToParse
}


//parsing to create SongMetadata object that contains MeasureMetadata objects that contain NoteMetadata objects
//CURRENTLY HOTCODED FOR PART 1 ONLY
func parseMusicXML() -> PlaySongMetadata {
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
      
    songToParse.key = [Int(xml["score-partwise"]["part"][0]["measure"][0]["attributes"]["key"]["fifths"].element!.text) ?? 4 : xml["score-partwise"]["part"][0]["measure"][0]["attributes"]["key"]["mode"].element!.text ]
    //0 and "major" are default values which is C major, no sharps or flats
      
    songToParse.timeSignature = [ Int( xml["score-partwise"]["part"][0]["measure"][0]["attributes"]["time"]["beats"].element!.text ) ?? 4 : Int( xml["score-partwise"]["part"][0]["measure"][0]["attributes"]["time"]["beat-type"].element!.text ) ?? 4 ]
    
    //currently handles first clef (usually right hand melody)
    songToParse.clef = [ xml["score-partwise"]["part"][0]["measure"][0]["attributes"]["clef"][0]["sign"].element!.text : Int(xml["score-partwise"]["part"][0]["measure"][0]["attributes"]["clef"][0]["line"].element!.text) ?? 2]
      
    songToParse.numMeasures = xml["score-partwise"]["part"][0]["measure"].all.count
    
    //create array of MeasureMetadatas by measureNumber
    //currently doesn't handle multiple parts
    for index in 1...songToParse.numMeasures {
        songToParse.measures.append( parseMeasureMusicXML(measureNumber: index) )
    }
    
    return songToParse
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
