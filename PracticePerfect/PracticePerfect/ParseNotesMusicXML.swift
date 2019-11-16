//
//  ParseNotesMusicXML.swift
//  PracticePerfect
//
//  Created by Abigail Chen on 11/16/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//

import SwiftUI
import SWXMLHash

var noteMusicXML : String = "temp"

//initialize SWXMLHash object
let noteSWXML = SWXMLHash.config {
            config in
            config.shouldProcessLazily = false
}.parse(noteMusicXML)

//parsing to create NoteMetadata object
func parseMusicXMLForNote() -> NoteMetadata {
    
    let noteToParse = NoteMetadata()
    
    //***rest parser code coming here***

    return noteToParse
}

var noteToParse = parseMusicXMLForNote()




struct ParseNotesMusicXML: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ParseNotesMusicXML_Previews: PreviewProvider {
    static var previews: some View {
        ParseNotesMusicXML().previewLayout(.fixed(width: 896, height: 414))
    }
}
