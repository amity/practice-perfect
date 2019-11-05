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
    // Needed to display the navigation bar after being hidden on SongInfoView, however we may not even want the navigation bar on this screen either, which would allow us to remove this variable potentially 
    @Binding var isNavigationBarHidden: Bool
    
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
        .onAppear {
            self.isNavigationBarHidden = false
        }
    }
}

// Can't preview because don't know how to simulate passing in bound value...
//struct PlayMode_Previews: PreviewProvider {
//    static var previews: some View {
//        // Preview with example song metadata
//        PlayMode(songMetadata: SongMetadata(id: 0, name: "Mary Had a Little lamb", highScore: 1000, rank: "S"), isNavigationBarHidden: true).previewLayout(.fixed(width: 896, height: 414))
//    }
//}
