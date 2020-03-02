//
//  PracticeCategoryView.swift
//  PracticePerfect
//
//  Created by Anna Matusewicz on 11/17/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//

import SwiftUI

struct ScalePicker: View {
    @Binding var rootIsActive : Bool
    
    let tempoValues = Array(0...200)
    let scales: [ScaleMetadata] = musicData["scales"] ?? []
    let modes = ["Major", "Minor"]
    let types = ["Scale", "Arpeggio"]
    
    @State private var selectedTempo = 100
    @State private var selectedKey = 0
    @State private var selectedMode = 0
    @State private var selectedType = 0
    
    // File retrieval methods adapted from:
    // https://www.raywenderlich.com/3244963-urlsession-tutorial-getting-started
    private func getXML(url: String) {
        trying = true
        dataTask?.cancel()
        
        if var urlComponents = URLComponents(string: url) {
            guard let url = urlComponents.url else {
                trying = false
                return
            }
            
            dataTask = downloadSession.dataTask(with: url) { (data, response, error) in
                defer {
                    self.dataTask = nil
                }

                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data, let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    self.XMLString = String(data: data, encoding: .utf8) ?? ""
                    self.finishedDownloading = true
                    self.canProceed = true
                }
            }
            dataTask?.resume()
        }
        trying = false
    }
    
    // XML Retrieval
    @State var downloadSession = URLSession(configuration: .default)
    @State var dataTask: URLSessionDataTask?
    @State var errorMessage = ""
    @State var results = ""
    @State var XMLString = ""
    @State var finishedDownloading = false
    @State var trying = false
    @State var canProceed: Bool = false
    
    var body: some View {
        ZStack {
            mainGradient
            HStack {
                Spacer()
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
                    Text("Key")
                        .font(Font.system(size:32).weight(.bold))
                    Picker(selection: $selectedKey, label: EmptyView()) {
                        ForEach(0 ..< scales.count) {
                            Text(String(self.scales[$0].name))
                        }
                    }.labelsHidden()
                    .frame(maxWidth: 150)
                    .clipped()
                }
                VStack {
                    Text("Mode")
                        .font(Font.system(size:32).weight(.bold))
                    Picker(selection: $selectedMode, label: EmptyView()) {
                        ForEach(0 ..< modes.count) {
                            Text(self.modes[$0])
                        }
                    }.labelsHidden()
                    .frame(maxWidth: 150)
                    .clipped()
                }
                VStack {
                    Text("Type")
                        .font(Font.system(size:32).weight(.bold))
                    Picker(selection: $selectedType, label: EmptyView()) {
                        ForEach(0 ..< types.count) {
                            Text(self.types[$0])
                        }
                    }.labelsHidden()
                    .frame(maxWidth: 150)
                    .clipped()
                }
                Spacer()
                if self.selectedType == 0 {
                    NavigationLink(destination: BackgroundFilter(rootIsActive: self.$rootIsActive, songMetadata: SongMetadata(songId: -1, name: scales[self.selectedKey].name + " " + modes[self.selectedMode] + " " + types[self.selectedType], artist: "", resourceUrl: scales[self.selectedKey].urls[self.selectedMode], year: -1, level: -1, topScore: -1, highScore: -1, highScoreId: -1, deleted: false, rank: ""), tempo: self.tempoValues[self.selectedTempo], timeSig: (4,4), showPrevious: false, xmlString: self.XMLString), isActive: $canProceed) {

                        EmptyView()
                    }
                        .isDetailLink(false)
                    
                    Button(action: {
                        self.getXML(url: self.scales[self.selectedKey].urls[self.selectedMode])
                    }) {
                        HStack {
                            Text("Play")
                        }
                    }
                    .modifier(MenuButtonStyle())
                } else {
                    NavigationLink(destination: BackgroundFilter(rootIsActive: self.$rootIsActive, songMetadata: SongMetadata(songId: -1, name: scales[self.selectedKey].name + " " + modes[self.selectedMode] + " " + types[self.selectedType], artist: "", resourceUrl: scales[self.selectedKey].arpeggioUrls[self.selectedMode], year: -1, level: -1, topScore: -1, highScore: -1, highScoreId: -1, deleted: false, rank: ""), tempo: self.tempoValues[self.selectedTempo], timeSig: (4,4), showPrevious: false, xmlString: self.XMLString), isActive: $canProceed) {

                        EmptyView()
                    }
                        .isDetailLink(false)
                    
                    Button(action: {
                        self.getXML(url: self.scales[self.selectedKey].arpeggioUrls[self.selectedMode])
                    }) {
                        HStack {
                            Text("Play")
                        }
                    }
                    .modifier(MenuButtonStyle())
                }
                Spacer()
            }
        }
    }
}

struct PracticeCategory_Previews: PreviewProvider {
    static var previews: some View {
        ScalePicker(rootIsActive: .constant(false)).previewLayout(.fixed(width: 896, height: 414))
    }
}
