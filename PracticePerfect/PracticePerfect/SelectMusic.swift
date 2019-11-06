//
//  SelectMusic.swift
//  Practice Perfect
//
//  Created by Abigail Chen on 11/3/19.
//  Copyright © 2019 CS98 Practice Perfect. All rights reserved.
//
//  Used this video tutorial for the scrolling animations:
//  https://www.youtube.com/watch?v=EBbhIbI2Hg8

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
            Spacer()
            Text("What song will you play?")
                .font(.system(size: 44))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 5) {
                    ForEach(songData) { songMetadata in
                        GeometryReader { geometry in
                            Button(action: {
                                self.showModal.toggle()
                                self.songMetadata = songMetadata
                            }) {
                                SongThumbnail(songMetadata: songMetadata)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .rotation3DEffect(Angle(degrees:
                                (Double(geometry.frame(in: .global).minX) - Double(UIScreen.main.bounds.width / 2) + Double(150)) / -20
                                ), axis: (x: 0, y: 10.0, z: 0))
                            // Show modal sheet (pop-up SongInfoView) for more information
                            .sheet(isPresented: self.$showModal, onDismiss: {
                                print(self.showModal)
                            }) {
                                SongInfoView(songMetadata: self.songMetadata)
                            }
                        }
                        .frame(width: 300, height: 185)
                    }
                }
                .padding(30)
            }
            // This could be used in the future for starting with the first song in the middle of the scrollview
//            .content.offset(x: (UIScreen.main.bounds.width / 2) + 150, y: 0)
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
