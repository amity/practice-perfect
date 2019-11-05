//
//  SelectMusic.swift
//  Practice Perfect
//
//  Created by Abigail Chen on 11/3/19.
//  Copyright © 2019 CS98 Practice Perfect. All rights reserved.
//

import SwiftUI

// Will eventually be retrieved from backend
let songData = [
    SongMetadata(id: 0, name: "Mary Had a Little Lamb", highScore: 1000, rank: "S"),
    SongMetadata(id: 1, name: "Joy to the World", highScore: 2000, rank: "S"),
    SongMetadata(id: 2, name: "Minuet in G", highScore: 1500, rank: "S"),
    SongMetadata(id: 3, name: "For He's a Jolly Good Fellow", highScore: 2500, rank: "S"),
    SongMetadata(id: 4, name: "Twinkle Twinkle Little Star", highScore: 2000, rank: "S")
]

struct SelectMusic: View {
    // Controls display of modal sheet 
    @State private var showModal = false
    // Need default value -- songData[0]
    @State private var songMetadata: SongMetadata = songData[0]
    
    var body: some View {
        VStack{
            Text("What song will you play?")
                .font(.system(size: 44))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(songData) { songMetadata in
                        Button(action: {
                            self.showModal.toggle()
                            self.songMetadata = songMetadata
                        }) {
                            SongThumbnail(songMetadata: songMetadata)
                        }
                        .buttonStyle(PlainButtonStyle())
                        // Show modal sheet (pop-up SongInfoView) for more information
                        .sheet(isPresented: self.$showModal, onDismiss: {
                            print(self.showModal)
                        }) {
                            SongInfoView(songMetadata: self.songMetadata)
                        }
                    }
                }
            }
        }
        .padding()
        .navigationBarItems(trailing:
            NavigationLink(destination: AddMusic()) {
                Text("Add music")
            }
        )
    }
}

struct SelectMusic_Previews: PreviewProvider {
    static var previews: some View {
        SelectMusic().previewLayout(.fixed(width: 896, height: 414))
    }
}
