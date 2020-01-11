//
//  PracticeCategoryView.swift
//  PracticePerfect
//
//  Created by Anna Matusewicz on 11/17/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//

import SwiftUI

struct PracticeCategory: View {
    var category: String
    var pieces: [MusicXMLMetadata]
    
    let tempoValues = Array(0...200)
    @State private var selectedTempo = 100
    
    var body: some View {
        HStack {
            VStack {
                Text("Tempo")
                    .font(Font.system(size:32).weight(.bold))
                Picker(selection: $selectedTempo, label: EmptyView()) {
                    ForEach(0 ..< tempoValues.count) {
                        Text(String(self.tempoValues[$0]))

                    }
                }.labelsHidden()
                .frame(maxWidth: 150)
                .clipped()
            }
            VStack {
                List(pieces) { piece in
                    NavigationLink(destination: PlayMode(songMetadata: SongMetadata(id: -1, name: piece.name, artist: "", resourceUrl: piece.url, year: -1, level: -1, topScore: -1, highScore: -1, deleted: false, rank: ""), tempo: self.selectedTempo, timeSig: (4,4))) {
                        Text(piece.name)
                    }
                }.listStyle(GroupedListStyle())
            }
            .navigationBarTitle(category)
        }
    }
}

struct PracticeCategory_Previews: PreviewProvider {
    static var previews: some View {
        PracticeCategory(category: "Major Scales", pieces: musicData["major"] ?? []).previewLayout(.fixed(width: 896, height: 414))
    }
}
