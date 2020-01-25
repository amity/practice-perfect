//
//  SongInfoView.swift
//  PracticePerfect
//
//  Created by Sean Hawkins on 11/5/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//

import SwiftUI

struct SongInfoView: View {
    // Song metadata passed from song selection - used to retrieve music data from backed through API
    @State var songMetadata: SongMetadata
    
    let tempoValues = Array(0...200)
    
    // These need to be in the API eventually - time signature and default tempo
    @State private var selectedTempo = 100
    let timeSig = (4,4)

    var body: some View {
        ZStack {
            mainGradient
            HStack {
                VStack {
                    Text(songMetadata.name)
                        .font(.system(size: 52))
                        .padding(.bottom, 15)
                        .fixedSize()
                    HStack {
                        Text("High Score: ")
                            .font(.system(size: 42))
                            .padding(.top, 5)
                        Spacer()
                        Text("\(songMetadata.highScore)")
                            .font(.system(size: 42))
                            .padding(.top, 5)
                    }
                    HStack {
                        Text("Rank: ")
                            .font(.system(size: 42))
                            .padding(.top, 5)
                        Spacer()
                        Text(songMetadata.rank)
                            .font(.system(size: 42))
                            .padding(.top, 5)
                    }
                    HStack {
                        Text("Artist: ")
                            .font(.system(size: 42))
                            .padding(.top, 5)
                        Spacer()
                        Text("\(songMetadata.artist)")
                            .font(.system(size: 42))
                            .padding(.top, 5)
                    }
                    HStack {
                        Text("Year: ")
                            .font(.system(size: 42))
                            .padding(.top, 5)
                        Spacer()
                        Text("\(String(songMetadata.year))")
                            .font(.system(size: 42))
                            .padding(.top, 5)
                    }
                }
                HStack {
                    Spacer()
                    VStack {
                        Text("Tempo")
                            .font(Font.system(size:20).weight(.bold))
                        Picker(selection: $selectedTempo, label: EmptyView()) {
                            ForEach(0 ..< tempoValues.count) {
                                Text(String(self.tempoValues[$0]))
                            }
                        }.labelsHidden()
                            .frame(maxWidth: 100, maxHeight: 70)
                            .clipped()
                    }
                    Spacer()
                    NavigationLink(destination: PlayMode(songMetadata: songMetadata, tempo: self.tempoValues[self.selectedTempo], timeSig: timeSig)) {
                        Text("Play!")
                        .font(.system(size: 32))
                    }
                        .modifier(MenuButtonStyle())
                    Spacer()
                }
            }
                .font(.system(size: 32))
        }
    }
}

struct SongInfoView_Previews: PreviewProvider {
    static var previews: some View {
        // Example with sample SongMetadata
        SongInfoView(songMetadata: SongMetadata(songId: -1, name: "", artist: "", resourceUrl: "", year: -1, level: -1, topScore: -1, highScore: -1, highScoreId: -1, deleted: false, rank: "")).previewLayout(.fixed(width: 896, height: 414))
    }
}
