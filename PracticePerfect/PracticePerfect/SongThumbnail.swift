//
//  SongThumbnail.swift
//  PracticePerfect
//
//  Created by Sean Hawkins on 11/3/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//

import SwiftUI

// When I put this variable in .padding() I get an error in line 30, but not sure why that would happen... 
var PADDING_WIDTH = 20

struct SongThumbnail: View {
    var songMetadata: SongMetadata
    
    var body: some View {
        ZStack{
            Color.gray
                .padding(10)
            VStack {
                Text(songMetadata.name)
                    .font(.system(size: 34))
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                Spacer()
                Text(songMetadata.artist)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)
                Spacer()
                HStack {
                    Text(songMetadata.rank)
                        .padding(.leading, 20)
                        .padding(.bottom, 20)
                    Spacer()
                    Text("\(songMetadata.highScore)")
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                }
            }
                .font(.system(size: 30))
                .padding(10)
        }
    }
}

struct SongThumbnail_Previews: PreviewProvider {
    static var previews: some View {
        // Example with sample SongMetadata
        SongThumbnail(songMetadata: SongMetadata(id: 0, name: "Mary Had a Little lamb", artist: "Unknown", highScore: 1000, rank: "S", level: 1)).previewLayout(.fixed(width: 300, height: 300))
    }
}
