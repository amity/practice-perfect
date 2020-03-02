//
//  SongThumbnail.swift
//  PracticePerfect
//
//  Created by Sean Hawkins on 11/3/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//

import SwiftUI

// When I put this variable in .padding() I get an error in line 30, but not sure why that would happen... 
var PADDING_WIDTH: CGFloat = screenWidth * 0.02

struct SongThumbnail: View {
    var songMetadata: SongMetadata
    
    var body: some View {
        ZStack{
            VStack {
                Text(songMetadata.name)
                    .fixedSize(horizontal: true, vertical: false)
                    .font(.largeTitle)
                    .padding(.top, PADDING_WIDTH)
                    .padding(.horizontal, PADDING_WIDTH)
                Spacer()
                Text(songMetadata.artist)
                    .fixedSize(horizontal: true, vertical: false)
                    .font(.title)
                    .padding(.bottom, PADDING_WIDTH)
                    .padding(.horizontal, PADDING_WIDTH)
                Spacer()
                HStack {
                    Text(songMetadata.rank)
                        .font(.largeTitle)
                        .padding(.leading, PADDING_WIDTH)
                        .padding(.bottom, PADDING_WIDTH)
                    Spacer()
                    Text("\(songMetadata.highScore)")
                        .font(.largeTitle)
                        .padding(.trailing, PADDING_WIDTH)
                        .padding(.bottom, PADDING_WIDTH)
                }
            }
            .padding(PADDING_WIDTH)
        }
        .foregroundColor(.white)
        .background(LinearGradient(gradient: Gradient(colors: [darkGreen, lightGreen]), startPoint: .leading, endPoint: .trailing).padding(10))
        .cornerRadius(40)
    }
}

struct SongThumbnail_Previews: PreviewProvider {
    static var previews: some View {
        // Example with sample SongMetadata
        SongThumbnail(songMetadata: SongMetadata(songId: -1, name: "", artist: "", resourceUrl: "", year: -1, level: -1, topScore: -1, highScore: -1, highScoreId: -1, deleted: false, rank: "")).previewLayout(.fixed(width: 300, height: 300))
    }
}
