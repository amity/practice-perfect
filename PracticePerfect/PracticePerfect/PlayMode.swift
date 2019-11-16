//
//  PlayMode.swift
//  Practice Perfect
//
//  Created by Abigail Chen on 11/3/19.
//  Copyright © 2019 CS98 Practice Perfect. All rights reserved.
//

import SwiftUI

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

// Star multiplier values for 1 through 5 stars (at indices 0 through 4)
let starMultValues: Array<Float> = [1, 1.5, 2.5, 4.5, 8.5]
// Streak multiplier values for streaks of length 0, 25, 50, and 100 (respectively)
let streakMultValues: Array<Float> = [1, 1.2, 1.5, 2]

struct PlayMode: View {
    // Song metadata passed from song selection - used to retrieve music data from backed through API
    var songMetadata: SongMetadata
    // Needed to display the navigation bar after being hidden on SongInfoView, however we may not even want the navigation bar on this screen either, which would allow us to remove this variable potentially 
    @Binding var isNavigationBarHidden: Bool
    
    // SCORING PARAMETERS
    // Total score: running count, @State displayed to the user
    @State var totalScore: Float = 0
    // Star multiplier: more difficult songs get you more points overall
    lazy var starMult: Float = starMultValues[songMetadata.level]
    // Streak count: number of correct notes in a row, @State displayed to user; used for calculating accuracy multiplier 
    @State var streakCount: Int = 0
    // Streak multiplier: as you get more and more notes correct in a row, you get a higher multipler (index increases as user gets longer streaks); streak count, index, and multiplier are reset when the user misses a note (but not as long as they get good or perfect)
    var streakIndex: Int = 0
    lazy var streakMultiplier: Float = streakMultValues[streakIndex]
    // TO DO: Add parameter for speed?
    
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
            HStack{
                Text("Score")
                // TO DO: Right now, sends new high score to server when pause button is pressed. This will need to be updated
                Button(action: {postSongs()}) {
                    Text("Pause").foregroundColor(Color.black)
                }
            }
            
            //placeholder image here
            
            HStack {
                Text("Progress")
            }
            
            NavigationLink(destination: ResultsPage(scoreMetadata: scoreMetadata, prevHighScore: songMetadata.highScore, isNavigationBarHidden: $isNavigationBarHidden)) {
                Text("Results")
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
        PlayMode(songMetadata: SongMetadata(id: 0, name: "Mary Had a Little lamb", highScore: 1000, rank: "S", level: 1), isNavigationBarHidden: .constant(false)).previewLayout(.fixed(width: 896, height: 414))
    }
}
