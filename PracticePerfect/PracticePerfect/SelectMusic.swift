//
//  SelectMusic.swift
//  Practice Perfect
//
//  Created by Abigail Chen on 11/3/19.
//  Copyright © 2019 CS98 Practice Perfect. All rights reserved.
//
//  API functions inspired by these comments on StackOverflow:
//  https://stackoverflow.com/a/24321320
//  https://stackoverflow.com/a/26365148
//  https://stackoverflow.com/a/25622593
//
//  This link contains info on semaphores, which are necessary for loading the songs from the API:
//  https://medium.com/@michaellong/how-to-chain-api-calls-using-swift-5s-new-result-type-and-gcd-56025b51033c

import SwiftUI

func parseJson(anyObj:Any?) -> Array<SongMetadata> {
    // Will eventually be retrieved from backend - in current state you can see the first three songs here followed by the two from the server (11/6/19). Eventually, the list will be initialized as empty
//    var list:Array<SongMetadata> = []
    var list = [
        SongMetadata(id: 0, name: "Mary Had a Little Lamb", highScore: 1000, rank: "S"),
        SongMetadata(id: 1, name: "Joy to the World", highScore: 2000, rank: "S"),
        SongMetadata(id: 2, name: "Minuet in G", highScore: 1500, rank: "S"),
    ]

    if  anyObj is Array<AnyObject> {
        for json in anyObj as! Array<AnyObject>{
            // More information will eventually come from the server
            let id = (json["id"]  as AnyObject? as? Int) ?? 0
            let name = (json["name"] as AnyObject? as? String) ?? ""
            let artist = (json["artist"] as AnyObject? as? String) ?? ""
            list.append(SongMetadata(id: id, name: name, highScore: 0, rank: "A"))
        }
    }

    return list
}

func retrieveSongs() -> Array<SongMetadata> {
    // Create the request
    let url = URL(string: "https://practiceperfect.appspot.com/songs")!
    let session = URLSession.shared
    var request = URLRequest(url: url)
    request.httpMethod = "GET"

    var songData: Array<SongMetadata> = []
    let semaphore = DispatchSemaphore(value: 0)
    let task = session.dataTask(with: request) { data, response, error in
        // Unwrap data
        guard let unwrappedData = data else {
            print(error!)
            return
        }
        // Get json object from data
        let jsonObj = try? JSONSerialization.jsonObject(with: unwrappedData, options: JSONSerialization.ReadingOptions.allowFragments)

        songData = parseJson(anyObj: jsonObj)
        print(songData)
        semaphore.signal()
    }
    task.resume()

    // Wait for the songs to be retrieved before displaying all of them
    _ = semaphore.wait(wallTimeout: .distantFuture)
    
    return songData
}

struct SelectMusic: View {
    // Controls display of modal sheet
    @State private var showModal = false
    // Need default value - dummy data to start with
    @State private var songMetadata: SongMetadata = SongMetadata(id: -1, name: "", highScore: -1, rank: "")
    // List of all songs
    @State var allSongs: Array<SongMetadata> = retrieveSongs()

    var body: some View {
        VStack{
            HStack {
                Text("What song will you play?")
                    .font(.system(size: 44))
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(self.allSongs) { songMetadata in
                        Button(action: {
                            self.showModal.toggle()
                            self.songMetadata = songMetadata
                        }) {
                            SongThumbnail(songMetadata: songMetadata)
                        }
                        .buttonStyle(PlainButtonStyle())
                        // Show modal sheet (pop-up SongInfoView) for more information
                        .sheet(isPresented: self.$showModal, onDismiss: {
                            print(self.showModal)
                        }) {
                            SongInfoView(songMetadata: self.songMetadata)
                        }
                    }
                }
            }
        }
        .padding()
        .navigationBarItems(trailing:
            NavigationLink(destination: AddMusic()) {
                Text("Add music")
            }
        )
    }
}

struct SelectMusic_Previews: PreviewProvider {
    static var previews: some View {
        SelectMusic(allSongs: [SongMetadata(id: -1, name: "", highScore: -1, rank: "")]).previewLayout(.fixed(width: 896, height: 414))
    }
}
