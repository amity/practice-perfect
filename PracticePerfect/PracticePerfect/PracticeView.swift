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
            List {
                NavigationLink(destination: PracticeCategory(category: "Major Scales", pieces: majorScales)) {
                    Text("Major Scales")
                }
                NavigationLink(destination: PracticeCategory(category: "Minor Scales", pieces: minorScales)) {
                    Text("Minor Scales")
                }
            }.listStyle(GroupedListStyle())
        }
        .navigationBarTitle("Practice Categories")
    }
}

struct PracticeView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeView().previewLayout(.fixed(width: 896, height: 414))
    }
}
