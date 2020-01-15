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
                        .font(.system(size: 48))
                        .padding(.bottom, 15)
                        .fixedSize()
                    HStack {
                        Text(songMetadata.rank)
                            .font(.system(size: 42))
                            .padding(.top, 5)
                        Spacer()
                        Text("\(songMetadata.highScore)")
                            .font(.system(size: 42))
                            .padding(.top, 5)
                    }
                    HStack {
                        Text("\(songMetadata.artist)")
                        Spacer()
                        Text("\(String(songMetadata.year))")
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
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
                    .padding(.top, 10)
                }
                .padding(.leading, 50)
                .padding(.trailing, 50)
                ZStack {
                    Color.gray
                    Text("Graphs/Visualization: History of scores/percents over time. Could have scoreboard information as well. ")
                        .padding(20)
                }
                .padding(50)
            }
                .font(.system(size: 32))
        }
    }
}

struct SongInfoView_Previews: PreviewProvider {
    static var previews: some View {
        // Example with sample SongMetadata
        SongInfoView(songMetadata: SongMetadata(id: -1, name: "", artist: "", resourceUrl: "", year: -1, level: -1, topScore: -1, highScore: -1, deleted: false, rank: "")).previewLayout(.fixed(width: 896, height: 414))
    }
}
