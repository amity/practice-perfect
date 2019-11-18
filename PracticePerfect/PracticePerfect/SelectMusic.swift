//
//  SelectMusic.swift
//  Practice Perfect
//
//  Created by Abigail Chen on 11/3/19.
//  Copyright © 2019 CS98 Practice Perfect. All rights reserved.
//
//  Used this video tutorial for the scrolling animations:
//  https://www.youtube.com/watch?v=EBbhIbI2Hg8
//
//  API functions inspired by these comments on StackOverflow:
//  https://stackoverflow.com/a/24321320
//  https://stackoverflow.com/a/26365148
//  https://stackoverflow.com/a/25622593
//
//  This link contains info on semaphores, which are necessary for loading the songs from the API:
//  https://medium.com/@michaellong/how-to-chain-api-calls-using-swift-5s-new-result-type-and-gcd-56025b51033c

import SwiftUI

// Take song data json and dictionary of song id to score and return list of SongMetadata for each song
func parseSongJson(anyObj:Any?, scoresDict: Dictionary<Int, Int>) -> Array<SongMetadata> {
    // Will eventually be retrieved fully from backend - in current state you can see the first three songs here followed by the two from the server (11/14/19). Eventually, the list will be initialized as empty (as seen in the following line)
    var list:Array<SongMetadata> = []

    if  anyObj is Array<AnyObject> {
        for json in anyObj as! Array<AnyObject>{
            let id = (json["id"]  as AnyObject? as? Int) ?? 0
            let name = (json["title"] as AnyObject? as? String) ?? ""
            let artist = (json["artist"] as AnyObject? as? String) ?? ""
            let level = (json["level"] as AnyObject? as? Int) ?? 1
            // Get high score for give song by indexing into scores list with id
            list.append(SongMetadata(id: id, name: name, artist: artist, highScore: scoresDict[id] ?? 0, rank: "A", level: level))
        }
    }

    return list
}

// Parses score results retrieved from server. Returns dictionary of song id to score
func parseScoresJson(anyObj:Any?) -> Dictionary<Int, Int> {
    var scoresDict: Dictionary<Int, Int> = [:]

    if  anyObj is Array<AnyObject> {
        for json in anyObj as! Array<AnyObject>{
            let id = (json["id"] as AnyObject? as? Int) ?? 0
            let score = (json["score"] as AnyObject? as? Int) ?? 0
            scoresDict[id] = score
        }
    }

    return scoresDict
}

// Retrieves data and initializes SongMetadata for each song, returned in an array
func retrieveSongs() -> Array<SongMetadata> {
    // Retrieve all scores for current user - list of scores in order of song id
    // Placeholder user id 0 --> will be dynamic once we implement authentication and users
    let scoreUrl = URL(string: "https://practiceperfect.appspot.com/scores/" + String(1))!
    let scoreSession = URLSession.shared
    var scoreRequest = URLRequest(url: scoreUrl)
    scoreRequest.httpMethod = "GET"

    var allScores: Dictionary<Int, Int> = [:]
    let scoreSemaphore = DispatchSemaphore(value: 0)
    let scoreTask = scoreSession.dataTask(with: scoreRequest) { data, response, error in
        // Unwrap data
        guard let unwrappedData = data else {
            print(error!)
            return
        }
        // Get json object from data
        let jsonObj = try? JSONSerialization.jsonObject(with: unwrappedData, options: JSONSerialization.ReadingOptions.allowFragments)

        allScores = parseScoresJson(anyObj: jsonObj)
        scoreSemaphore.signal()
    }
    scoreTask.resume()

    // Wait for the songs to be retrieved before displaying all of them
    _ = scoreSemaphore.wait(wallTimeout: .distantFuture)

    // Retrieve song data and parse (passing score data to parseSongJson) 
    let songUrl = URL(string: "https://practiceperfect.appspot.com/songs")!
    let songSession = URLSession.shared
    var songRequest = URLRequest(url: songUrl)
    songRequest.httpMethod = "GET"

    var songData: Array<SongMetadata> = []
    let songSemaphore = DispatchSemaphore(value: 0)
    let songTask = songSession.dataTask(with: songRequest) { data, response, error in
        // Unwrap data
        guard let unwrappedData = data else {
            print(error!)
            return
        }
        // Get json object from data
        let jsonObj = try? JSONSerialization.jsonObject(with: unwrappedData, options: JSONSerialization.ReadingOptions.allowFragments)

        songData = parseSongJson(anyObj: jsonObj, scoresDict: allScores)
        songSemaphore.signal()
    }
    songTask.resume()

    // Wait for the songs to be retrieved before displaying all of them
    _ = songSemaphore.wait(wallTimeout: .distantFuture)
    
    return songData
}

struct SelectMusic: View {
    // Controls display of modal sheet
    @State private var showModal = false
    // Need default value - dummy data to start with
    @State private var songMetadata: SongMetadata = SongMetadata(id: -1, name: "", artist: "", highScore: -1, rank: "", level: -1)
    // List of all songs
    @State var allSongs: Array<SongMetadata> = retrieveSongs()

    @Binding var isNavigationBarHidden: Bool
    
    var body: some View {
        VStack{
            Spacer()
            Text("What song will you play?")
                .font(.system(size: 44))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 5) {
                    ForEach(allSongs) { songMetadata in
                        GeometryReader { geometry in
                            Button(action: {
                                self.showModal.toggle()
                                self.songMetadata = songMetadata
                            }) {
                                SongThumbnail(songMetadata: songMetadata)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .rotation3DEffect(Angle(degrees:
                                (Double(geometry.frame(in: .global).minX) - Double(UIScreen.main.bounds.width / 2) + Double(150)) / -20
                                ), axis: (x: 0, y: 10.0, z: 0))
                            // Show modal sheet (pop-up SongInfoView) for more information
                            .sheet(isPresented: self.$showModal, onDismiss: {
                                print(self.showModal)
                            }) {
                                SongInfoView(isNavigationBarHidden: self.$isNavigationBarHidden, songMetadata: self.songMetadata)
                            }
                        }
                        .frame(width: 300, height: 185)
                    }
                }
                .padding(30)
            }
            // This could be used in the future for starting with the first song in the middle of the scrollview
//            .content.offset(x: (UIScreen.main.bounds.width / 2) + 150, y: 0)
        }
        .padding()
        .navigationBarItems(trailing:
            NavigationLink(destination: AddMusic()) {
                Text("Add music")
            }
        )
        .onAppear {
            self.isNavigationBarHidden = false
        }
    }
}

struct SelectMusic_Previews: PreviewProvider {
    static var previews: some View {
        SelectMusic(allSongs: [SongMetadata(id: -1, name: "", artist: "", highScore: -1, rank: "", level: -1)], isNavigationBarHidden: .constant(false)).previewLayout(.fixed(width: 896, height: 414))
    }
}
