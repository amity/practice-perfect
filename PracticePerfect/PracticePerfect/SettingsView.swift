//
//  SettingsView.swift
//  PracticePerfect
//
//  Created by Anna Matusewicz on 11/3/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//

import SwiftUI

class UserSettings: ObservableObject {
    @Published var clefIndex = UserDefaults.standard.integer(forKey: "clefIndex")
    @Published var keyIndex = UserDefaults.standard.integer(forKey: "keyIndex")
}

struct SettingsView: View {
    @EnvironmentObject var settings: UserSettings
    
    let clefs = ["Treble", "Alto", "Bass"]
    let scales: [ScaleMetadata] = musicData["scales"] ?? []
    
    @State var selectedClef: Int
    @State var selectedKey: Int
        
    var body: some View {
        ZStack {
            mainGradient
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    HStack {
                        Text("What clef would you like to use?")
                            .font(Font.system(size:28).weight(.bold))
                            .frame(maxWidth: 300)
                        Spacer()
                        VStack {
                            Picker(selection: $selectedClef, label: EmptyView()) {
                                ForEach(0 ..< clefs.count) {
                                    Text(String(self.clefs[$0]))
                                }
                            }.labelsHidden()
                            .frame(maxWidth: 200)
                            .clipped()
                        }
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        Text("What key is your instrument tuned to?")
                            .font(Font.system(size:28).weight(.bold))
                            .frame(maxWidth: 300)
                        Spacer()
                        VStack {
                            Picker(selection: $selectedKey, label: EmptyView()) {
                                ForEach(0 ..< scales.count) {
                                    Text(String(self.scales[$0].name))
                                }
                            }.labelsHidden()
                            .frame(maxWidth: 200)
                            .clipped()
                        }
                        Spacer()
                    }
                    Spacer()
                }
                Spacer()
                VStack {
                    Button(action: {
                        UserDefaults.standard.set(self.selectedClef, forKey: "clefIndex")
                        self.settings.clefIndex = self.selectedClef
                        UserDefaults.standard.set(self.selectedKey, forKey: "keyIndex")
                        self.settings.keyIndex = self.selectedKey
                    }) {
                        Text("Save Preferences")
                    }
                            .modifier(MenuButtonStyle())
                }
                Spacer()
            }
        }
        .navigationBarTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(selectedClef: 0, selectedKey: 0)
    }
}
