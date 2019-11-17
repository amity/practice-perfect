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
    

    var body: some View {
        VStack {
            List(pieces) { piece in
                NavigationLink(destination: PieceDetail(piece: piece)) {
                    Text(piece.name)
                }
            }.listStyle(GroupedListStyle())
        }
        .navigationBarTitle(category)
    }
}

struct PracticeCategory_Previews: PreviewProvider {
    static var previews: some View {
        PracticeCategory(category: "Major Scales", pieces: musicData["major"] ?? []).previewLayout(.fixed(width: 896, height: 414))
    }
}
