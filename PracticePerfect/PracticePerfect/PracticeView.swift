//
//  PracticeView.swift
//  PracticePerfect
//
//  Created by Anna Matusewicz on 11/7/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//

import SwiftUI

struct PracticeView: View {
    @State private var showScales = false

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Button(action: {
                    self.showScales = true
                }) {
                    Text("Scales")
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            
        }
    }
    
    func parseMusicJson() {
        if let path = Bundle.main.path(forResource: "Exercises", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, Dictionary<String, Array<Dictionary<String, String>>>> {
                    let majorScales = jsonResult["scales"]!["major"]!
                    let minorScales = jsonResult["scales"]!["minor"]!
                }
              } catch {
                   // handle error
              }
        }
    }
}

struct PracticeView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeView().previewLayout(.fixed(width: 896, height: 414))
    }
}
