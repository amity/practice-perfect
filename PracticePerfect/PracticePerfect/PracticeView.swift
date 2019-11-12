//
//  PracticeView.swift
//  PracticePerfect
//
//  Created by Anna Matusewicz on 11/7/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//

import SwiftUI

struct PracticeView: View {
    @State var majorScales = musicData["major"] ?? []
    @State var minorScales = musicData["minor"] ?? []

    var body: some View {
        VStack {
            Text("Major Scales:") // STYLE
            List(majorScales) { piece in
                NavigationLink(destination: PieceDetail(piece: piece)) {
                    PieceRow(piece: piece)
                }
            }
            Text("Minor Scales:")
            List(minorScales) { piece in
                NavigationLink(destination: PieceDetail(piece: piece)) {
                    PieceRow(piece: piece)
                }
            }
        }
        .navigationBarTitle("Practice")
    }
}

struct PracticeView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeView().previewLayout(.fixed(width: 896, height: 414))
    }
}
