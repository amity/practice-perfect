//
//  SongInfoView.swift
//  PracticePerfect
//
//  Created by Sean Hawkins on 11/5/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//

import SwiftUI

struct SongInfoView: View {
    @Binding var rootIsActive : Bool
    
    // Song metadata passed from song selection - used to retrieve music data from backed through API
    @State var songMetadata: SongMetadata
    
    let tempoValues = Array(0...200)
    
    // These need to be in the API eventually - time signature and default tempo
    @State private var selectedTempo = 100
    let timeSig = (3,4)

    // File retrieval methods adapted from:
    // https://www.raywenderlich.com/3244963-urlsession-tutorial-getting-started
    private func getXML() {
        trying = true
        dataTask?.cancel()
        
        if var urlComponents = URLComponents(string: songMetadata.resourceUrl) {
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
    
    var body: some View {
        ZStack {
            mainGradient
            HStack {
                Spacer()

                VStack {
                    Spacer()

                    Text(songMetadata.name)
                        .font(.largeTitle)
                        .padding(.bottom, 10)

                    HStack {
                        Text("High Score: ")
                            .font(.largeTitle)
                        Spacer()
                        Text("\(songMetadata.highScore)")
                            .font(.largeTitle)
                    }
                    HStack {
                        Text("Rank: ")
                            .font(.largeTitle)
                        Spacer()
                        Text(songMetadata.rank)
                            .font(.largeTitle)
                    }
                    HStack {
                        Text("Artist: ")
                            .font(.largeTitle)
                        Spacer()
                        Text("\(songMetadata.artist)")
                            .font(.largeTitle)
                    }
                    HStack {
                        Text("Year: ")
                            .font(.largeTitle)
                        Spacer()
                        Text("\(String(songMetadata.year))")
                            .font(.largeTitle)
                    }

                    Spacer()
                }
                HStack {
                    Spacer()
                    VStack {
                        Text("Tempo")
                            .font(.title)
                        Picker(selection: $selectedTempo, label: EmptyView()) {
                            ForEach(0 ..< tempoValues.count) {
                                Text(String(self.tempoValues[$0]))
                            }
                        }.labelsHidden()
                            .frame(maxWidth: 100, maxHeight: 70)
                            .clipped()
                    }
                    
                    if self.finishedDownloading {
                        NavigationLink(destination: BackgroundFilter(rootIsActive: self.$rootIsActive, songMetadata: songMetadata, tempo: self.tempoValues[self.selectedTempo], timeSig: timeSig)) {
                            Text("Play!")
                                .font(.title)
                        }
                        .isDetailLink(false)
                        .modifier(MenuButtonStyle())
                    } else {
                        Button(action: {
                            self.getXML()
                        }) {
                            if trying {
                                Text("Downloading...")
                            } else {
                                Text("Download Song")
                            }
                        }
                            .modifier(MenuButtonStyle())
                        .disabled(trying)
                    }
                    
                    Spacer()
                }
            }
        }
        .foregroundColor(.black)
        .onAppear() {
            self.getXML()
        }
    }
}

struct SongInfoView_Previews: PreviewProvider {
    static var previews: some View {
        // Example with sample SongMetadata
        SongInfoView(rootIsActive: .constant(false), songMetadata: SongMetadata(songId: -1, name: "", artist: "", resourceUrl: "", year: -1, level: -1, topScore: -1, highScore: -1, highScoreId: -1, deleted: false, rank: "")).previewLayout(.fixed(width: 896, height: 414))
    }
}
