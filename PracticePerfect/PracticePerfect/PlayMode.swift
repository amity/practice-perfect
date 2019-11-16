//
//  PlayMode.swift
//  Practice Perfect
//
//  Created by Abigail Chen on 11/3/19.
//  Copyright © 2019 CS98 Practice Perfect. All rights reserved.
//

import SwiftUI

// Get screen dimensions
let screenSize: CGRect = UIScreen.main.bounds
let screenWidth = CGFloat(screenSize.width)
let screenHeight = CGFloat(screenSize.height)

//offsets from center to draw staff lines
let offsets : [CGFloat] = [screenWidth/8,screenWidth/8 * 2, 0, screenWidth/(-8), screenWidth/(-8) * 2]

//Currently loads local file to String
func loadXML2String(fileName : String, fileExtension: String) -> String {
    if let filepath = Bundle.main.path(forResource: fileName, ofType: fileExtension) {
        do {
            let contents = try String(contentsOfFile: filepath)
            print(contents)
            return(contents)
        } catch {
            return "file contents could not be loaded"
        }
    } else {
        return "file not found"
    }
}

//***TEMPORARILY HOT CODED TO LOCAL FILE APRES***
var musicXMLToParseFromFile: String = loadXML2String(fileName: "reve", fileExtension: "musicxml")





// Posts result score to update backend
// TO DO: Update parameters to include user id, song id, and score
func postSongs() -> () {
    // TO DO: Params from results passed into function - hard-coded right now
    let params = ["user": 0, "song": 0, "score": 1000] as Dictionary<String, Int>
    let scoreUrl = URL(string: "https://practiceperfect.appspot.com/scores")!
    let scoreSession = URLSession.shared
    var scoreRequest = URLRequest(url: scoreUrl)
    scoreRequest.httpMethod = "POST"
    scoreRequest.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
    
    let semaphore = DispatchSemaphore(value: 0)
    let task = scoreSession.dataTask(with: scoreRequest) { data, response, error in
        // TO DO: Error handling with response, currently just returns 200 which is what you would expect
        print(response!)
        semaphore.signal()
    }
    task.resume()

    // Wait for the songs to be retrieved before displaying all of them
    _ = semaphore.wait(wallTimeout: .distantFuture)
}

struct PlayMode: View {
    // Song metadata passed from song selection - used to retrieve music data from backed through API
    var songMetadata: SongMetadata
    // Needed to display the navigation bar after being hidden on SongInfoView, however we may not even want the navigation bar on this screen either, which would allow us to remove this variable potentially
    @Binding var isNavigationBarHidden: Bool
    
    // TO DO: Will be created from the score once play along mode is completed
    @State var scoreMetadata: ScoreMetadata = ScoreMetadata(
        overallRank: "A-",
        pitchRank: "A",
        tempoRank: "B+",
        newScore: 9000,
        scorePercent: 9123,
        perfectCount: 1431,
        goodCount: 237,
        missCount: 26
    )
    
    var body: some View {
        VStack {
            ZStack {
                
                VStack {
                    NavigationLink(destination: ResultsPage(scoreMetadata: scoreMetadata, prevHighScore: songMetadata.highScore, isNavigationBarHidden: $isNavigationBarHidden)) {
                            Text("Results")
                            }
                    }
                    .offset(x: 400, y: 175)
                
                VStack {
                    // TO DO: Right now, sends new high score to server when pause button is pressed. This will need to be updated
                    Button(action: {postSongs()}) {
                    Text("Pause").foregroundColor(Color.black)
                        }
                    }
                    .offset(x: 400, y: -160)
                
                VStack {
                    Text("You are playing: [song title]")
                    }
                    .offset(y: -160)
                
                VStack {
                    Text("Score: [num]")
                    }
                    .offset(x: -380, y: 175)

            //draws staff
            ZStack {
                ForEach(0 ..< offsets.count) { index in
                    Rectangle()
                        .frame(width: 1.0, height: CGFloat(screenHeight))
                        .offset(x: CGFloat(offsets[index]), y:0)
                        .rotationEffect(.degrees(-90))
                    }
                }
                
            //music notation
                ZStack {
                    Text("Music Notation")
                }
                .offset(x: -400)
            
            //notes
                ZStack {
                    Text("Notes")
                }
                
                
            }
            
        }
        .onAppear {
            self.isNavigationBarHidden = false
            }
      
        
    }
}



struct PlayMode_Previews: PreviewProvider {
    static var previews: some View {
        // Preview with example song metadata
        PlayMode(songMetadata: SongMetadata(id: 0, name: "Mary Had a Little lamb", artist: "Unknown", highScore: 1000, rank: "S"), isNavigationBarHidden: .constant(false)).previewLayout(.fixed(width: 896, height: 414))
    }
}
