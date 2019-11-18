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

    var body: some View {
        ZStack {
            mainGradient
            HStack {
                VStack {
                    Text(songMetadata.name)
                        .font(.system(size: 42))
                        .padding(.bottom, 15)
                        .fixedSize()
                    Text(songMetadata.rank)
                        .font(.system(size: 42))
                        .padding(.top, 5)
                    HStack {
                        // Percent will eventually be part of SongMetadata once it is in the backend
                        Text("93%")
                            .font(.system(size: 32))
                        Spacer(minLength: 100)
                        Text("\(songMetadata.highScore)")
                            .font(.system(size: 32))
                    }
                    .padding(.top, 10)
                    NavigationLink(destination: PlayMode(songMetadata: songMetadata)) {
                        Text("Play!")
                        .font(Font.custom("Arial Rounded MT Bold", size: 32))
                    }
                        .modifier(MenuButtonStyle())
                }
                .padding(50)
                ZStack {
                    Color.gray
                    Text("Graphs/Visualization: History of scores/percents over time. Could have scoreboard information as well. ")
                        .font(.system(size: 32))
                        .padding(20)
                }
                .padding(50)
            }
        }
    }
}
