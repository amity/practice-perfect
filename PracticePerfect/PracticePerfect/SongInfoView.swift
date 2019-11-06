//
//  SongInfoView.swift
//  PracticePerfect
//
//  Created by Sean Hawkins on 11/5/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//

import SwiftUI

struct SongInfoView: View {
    @Environment(\.presentationMode) var presentation
    // Keeps track of whether to hide the navigation bar (done for SongInfoView) or whether to show (all other views)
    @State var isNavigationBarHidden: Bool = true
    // Song metadata passed from song selection - used to retrieve music data from backed through API
    @State var songMetadata: SongMetadata

    var body: some View {
        NavigationView {
            HStack {
                ZStack {
                    Color.white
                    VStack {
                        Text(songMetadata.name)
                            .font(.system(size: 38))
                            .padding(20)
                            .fixedSize()
                        Text(songMetadata.rank)
                            .font(.system(size: 32))
                        Text("\(songMetadata.highScore)")
                            .font(.system(size: 32))
                        Text("Other info")
                            .font(.system(size: 28))
                        Text("More other info")
                            .font(.system(size: 28))
                        HStack {
                            ZStack {
                                Color.gray
                                NavigationLink(destination: PlayMode(songMetadata: songMetadata, isNavigationBarHidden: $isNavigationBarHidden)) {
                                    Text("Play!")
                                        .font(.system(size: 32))
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            Spacer()
                            ZStack {
                                Color.gray
                                Button(action: {
                                    self.presentation.wrappedValue.dismiss()
                                }) {
                                    Text("Dismiss")
                                        .font(.system(size: 32))
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
                .padding(50)
                ZStack {
                    Color.gray
                    Text("Graphs/Visualization")
                        .font(.system(size: 32))
                        .padding(20)
                }
                .padding(50)
            }
            .navigationBarTitle("")
            .navigationBarHidden(self.isNavigationBarHidden)
            .onAppear {
                self.isNavigationBarHidden = true
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
