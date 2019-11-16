//
//  ParseSongsMusicXML.swift
//  PracticePerfect
//
//  Created by Abigail Chen on 11/16/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//

import SwiftUI
import SWXMLHash

func getTotalNumNotes() -> Int {
    var count : Int = 0
    for measure in songToParse.measures {
        count += measure.notes.count
    }

    return count
}

//initialize SWXMLHash object
let playSongSWXML = SWXMLHash.config {
            config in
            config.shouldProcessLazily = false
}.parse(musicXMLToParseFromFile)

//parsing to create PlaySongMetadata object
func parseMusicXMLForSong() -> PlaySongMetadata {
    //create metadata object
    let songToParse = PlaySongMetadata()

    //***TEMPORARY HOT CODED SONG NUMBER*** -> WILL PULL FROM API
    songToParse.songNumber = 0

    //***rest parser code coming here***

    return songToParse
}

var songToParse = parseMusicXMLForSong()





struct ParseSongsMusicXML: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ParseSongsMusicXML_Previews: PreviewProvider {
    static var previews: some View {
        ParseSongsMusicXML().previewLayout(.fixed(width: 896, height: 414))
    }
}
