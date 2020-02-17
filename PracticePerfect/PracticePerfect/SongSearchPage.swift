//
//  SongSearchPage.swift
//  PracticePerfect
//
//  Created by Sean Hawkins on 1/15/20.
//  Copyright © 2020 CS98PracticePerfect. All rights reserved.
//
// Search page tutorial: https://www.youtube.com/watch?v=IHx53KJnL-o
// Gesture help: https://stackoverflow.com/a/59704606

import SwiftUI

struct SongSearchPage: View {
    @Binding var rootIsActive : Bool

    @State var songList: Array<SongMetadata>
    @State private var searchTerm: String = ""
        
    var body: some View {
        ZStack {
            mainGradient
            List {
                SearchBar(text: $searchTerm)
                ForEach(self.songList.filter {
                    self.searchTerm.isEmpty ? true :
                        ($0.name.localizedCaseInsensitiveContains(self.searchTerm) || $0.artist.localizedCaseInsensitiveContains(self.searchTerm))
                }, id: \.self) { song in
                    NavigationLink(destination: SongInfoView(rootIsActive: self.$rootIsActive, songMetadata: song)) {
                        Text(song.name + " by " + song.artist)
                    }
                    .isDetailLink(false)
                    // TO-DO STRETCH: This doesn't seem to be working right now... need another way to dismiss keyboard when changing page
                    .gesture(TapGesture().onEnded{_ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    })
                }
            }.frame(width: 500)
            .gesture(DragGesture().onChanged{_ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)})
        }
        // TO-DO STRETCH: This doesn't seem to be working right now... need another way to dismiss keyboard when changing page
        .onDisappear(perform: {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)})
    }
}

struct SongSearchPage_Previews: PreviewProvider {
    static var previews: some View {
        SongSearchPage(rootIsActive: .constant(false), songList: [])
    }
}
