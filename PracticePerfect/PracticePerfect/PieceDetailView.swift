//
//  PieceDetailView.swift
//  PracticePerfect
//
//  Created by Anna Matusewicz on 11/11/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//
// File adapted from lists tutorial:
// https://developer.apple.com/tutorials/swiftui/building-lists-and-navigation

import SwiftUI

struct PieceDetail: View {
    var piece: MusicXMLMetadata

    @State var downloadSession = URLSession(configuration: .default)
    @State var dataTask: URLSessionDataTask?
    @State var errorMessage = ""
    @State var results = ""
    @State var showCountdown = false
    
    let tempo = 120
    let beats = 4

    var body: some View {
        ZStack {
            mainGradient
            VStack {
                VStack {
                    Text(piece.name)
                    Button(action: {
                        self.getXML()
                    }) {
                        Text("Download Piece")
                    }
                }
                .padding()

                Spacer()
                
                Button(action: {
                        self.showCountdown = true
                    }) {
                        Text("Begin Piece")
                }
                
                Spacer()
            }
            .navigationBarTitle(Text(verbatim: piece.name), displayMode: .inline)
            .blur(radius: showCountdown ? 20 : 0)
            
            if showCountdown {
                Countdown(tempo: self.tempo, beats: self.beats, showCountdown: self.$showCountdown)
                    .animation(.easeInOut(duration: 4.0))
                    .transition(.opacity)
            }
        }
    }
    
    // File retrieval methods adapted from:
    // https://www.raywenderlich.com/3244963-urlsession-tutorial-getting-started
    func getXML() {
        dataTask?.cancel()
        
        if var urlComponents = URLComponents(string: piece.url) {
            guard let url = urlComponents.url else {
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
                    self.updateSearchResults(data)
                }
            }
            dataTask?.resume()
        }
    }

    private func updateSearchResults(_ data: Data) {
        let file = String(data: data, encoding: .utf8)
        print(file as Any)
    }
}

struct LandmarkDetail_Previews: PreviewProvider {
    static var previews: some View {
        PieceDetail(piece: musicData["major"]![0]).previewLayout(.fixed(width: 896, height: 414))
    }
}
