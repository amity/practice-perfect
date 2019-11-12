//
//  PieceRowView.swift
//  PracticePerfect
//
//  Created by Anna Matusewicz on 11/11/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//
// File adapted from lists tutorial:
// https://developer.apple.com/tutorials/swiftui/building-lists-and-navigation

import SwiftUI

struct PieceRow: View {
    var piece: MusicXMLMetadata

    var body: some View {
        HStack {
            Text(piece.name)
            Spacer()
        }
    }
}

struct PieceRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PieceRow(piece: musicData["major"]![0])
            PieceRow(piece: musicData["minor"]![1])
        }
        .previewLayout(.fixed(width: 896, height: 414))
    }
}
