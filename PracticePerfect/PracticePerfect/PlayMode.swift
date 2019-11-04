//
//  PlayMode.swift
//  Practice Perfect
//
//  Created by Abigail Chen on 11/3/19.
//  Copyright © 2019 CS98 Practice Perfect. All rights reserved.
//

import SwiftUI

struct PlayMode: View {
    // Song metadata passed from song selection - used to retrieve music data from backed through API
    var songMetadata: SongMetadata
    
    var body: some View {
        VStack {
            HStack{
                Text("Score")
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("Pause").foregroundColor(Color.black)
                }
            }
            
            //placeholder image here
            
            HStack {
                Text("Progress")
            }
            
        }
    }
}

struct PlayMode_Previews: PreviewProvider {
    static var previews: some View {
        // Preview with example song metadata
        PlayMode(songMetadata: SongMetadata(id: 0, name: "Mary Had a Little lamb", highScore: 1000, rank: "S")).previewLayout(.fixed(width: 896, height: 414))
    }
}
