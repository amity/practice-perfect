//
//  SettingsView.swift
//  PracticePerfect
//
//  Created by Anna Matusewicz on 11/3/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack{
            mainGradient

            HStack {
                Image(systemName: "paintbrush")
                Text("Coming soon!")
            }
        }
        .navigationBarTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
