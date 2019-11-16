//
//  ParseSongsMusicXML.swift
//  PracticePerfect
//
//  Created by Abigail Chen on 11/16/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//

import SwiftUI
import SWXMLHash

var songMusicXML : String = "temp"

//initialize SWXMLHash object
let playSongSWXML = SWXMLHash.config {
            config in
            config.shouldProcessLazily = false
}.parse(songMusicXML)

//***rest parser code coming here***



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
