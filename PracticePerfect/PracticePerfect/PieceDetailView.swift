//
//  PieceDetailView.swift
//  PracticePerfect
//
//  Created by Anna Matusewicz on 11/11/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//

import SwiftUI

struct PieceDetail: View {
    var piece: MusicXMLMetadata

    var body: some View {
        VStack {
            VStack {
                Text(piece.name)
                Text(piece.url)
            }
            .padding()

            Spacer()
        }
        .navigationBarTitle(Text(verbatim: piece.name), displayMode: .inline)
    }
}

struct LandmarkDetail_Previews: PreviewProvider {
    static var previews: some View {
        PieceDetail(piece: musicData["major"]![0])
    }
}
