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
let screenDivisions : CGFloat = 20
let offsets : [CGFloat] = [screenWidth/screenDivisions,screenWidth/screenDivisions * 2, 0, screenWidth/(-screenDivisions), screenWidth/(-screenDivisions) * 2]

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

// Star multiplier values for 1 through 5 stars (at indices 0 through 4)
let starMultValues: Array<Float> = [1, 1.5, 2.5, 4.5, 8.5]
// Streak multiplier values for streaks of length 0, 10, 25, and 50 (respectively)
let streakMultValues: Array<Float> = [1, 1.2, 1.5, 2]

struct PlayMode: View, TunerDelegate {
    // Song metadata passed from song selection - used to retrieve music data from backed through API
    var songMetadata: SongMetadata
    var tempo: Int
    var timeSig: (Int, Int)
    
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
        newScore: 850000,
        pitchPercent: 9560,
        tempoPercent: 9756,
        perfectPercent: 9400,
        goodPercent: 450,
        missPercent: 250
    )
    
    // Tuner variables
    @State var tuner = Tuner()
    @State var cents = 0.0
    @State var note = Note(Note.Name.c, Note.Accidental.natural)
    @State var isOn = true
    @State var tempoCount = 0
    
    // Countdown variables
    @State var showCountdown = true
    let beats = 4
    
    // Temporary scoring variables
    @State var currBeatNotes: [Note] = [] // For all notes in current beat
    // TO DO: get this from XML rather than hard-coding C major
    @State var correctNotes: [String] = ["C", "E", "G", "C"]
    @State var runningScore: Int = 0
    
    var body: some View {
        ZStack {
            mainGradient
        
            VStack{
                Spacer()

                HStack {
                    VStack {
                        Text(displayNote(note: note))
                            .modifier(NoteStyle())
                            .frame(minWidth: 175, maxWidth: 175)
                        if cents > 0 {
                            Text("\(roundToFive(num: cents)) cents sharp")
                        } else if cents < 0 {
                            Text("\(roundToFive(num: abs(cents))) cents flat")
                        } else {
                            Text("In tune!")
                        }
                        Text(String(tempoCount % timeSig.0 + 1))
                            .font(Font.system(size:64).weight(.bold))
                    }
                        .font(Font.system(size: 16).weight(.bold))

                    Spacer()

                    //draws staff
                    VStack {
                        ForEach(0 ..< 5) { index in
                            Rectangle()
                                .frame(width: 500.0, height: 1.0)
                                .padding(.bottom, screenWidth/screenDivisions/2)
                        }
                    }
                    
                    Spacer()
                }
                
                Spacer()
                
                HStack {
                    if isOn {
                        Button(action: {
                            self.tuner.stop()
                            self.isOn = false
                        }) {
                            Text("Pause")
                        }
                             .modifier(MenuButtonStyle())
                    } else {
                        Button(action: {
                            self.startTuner()
                        }) {
                            Text("Resume")
                        }
                             .modifier(MenuButtonStyle())
                    }
                    
                    Spacer()
                    
                    Text("Score: " + String(runningScore))
                        .font(Font.system(size: 64).weight(.bold))
                    
                    Spacer()
                    
                    NavigationLink(destination: ResultsPage(scoreMetadata: scoreMetadata, songMetadata: songMetadata)) {
                        Text("Results")
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        // TO DO: Right now, sends new high score to server when pause button is pressed. This will need to be updated
                            self.tuner.stop()
                            postSongs()
                        })
                        .modifier(MenuButtonStyle())
                }
                .padding(.bottom, 20)
            }
            .blur(radius: showCountdown ? 20 : 0)
            
            if showCountdown {
                Countdown(tempo: self.tempo, beats: self.beats, showCountdown: self.$showCountdown, callback: startTuner)
            }
        }
        .navigationBarTitle("You are playing: [song title]")
    }

    // Updates current note information from microphone
    func tunerDidTick(pitch: Pitch, frequency: Double, beatCount: Int, change: Bool) {
        // Convert beatCount to seconds by multiplying by sampling rate, then to minutes by dividing by 60. Then multiply by tempo (bpm) to get tempo count
        let newTempoCount = Int(Float(beatCount) * Float(0.05) / Float(60) * Float(tempo))
        
        // If not on new beat, add the note to the list of note readings for current beat
        if newTempoCount == tempoCount {
            currBeatNotes.append(pitch.note)
        }
        // If new beat, calculate score and empty list for next beat
        else {
            
            // Frequency calculation algorithm from: https://stackoverflow.com/questions/38416347/getting-the-most-frequent-value-of-an-array
            
            // Create dictionary to map value to count and get most frequent note
            var counts = [Note: Int]()
            currBeatNotes.forEach { counts[$0] = (counts[$0] ?? 0) + 1 }
            let (value, _) = counts.max(by: {$0.1 < $1.1}) ?? (Note(Note.Name(rawValue: 0)!,Note.Accidental(rawValue: 0)!), 0)
            
            // If correct note, then 10 points; if one half step away, then 5 points
            if displayNote(note: value) == correctNotes[tempoCount % timeSig.0] {
                runningScore += 10
            }
            else if displayNote(note: value.halfStepUp) == correctNotes[tempoCount % timeSig.0] {
                runningScore += 5
            }
            else if displayNote(note: value.halfStepDown) == correctNotes[tempoCount % timeSig.0] {
                runningScore += 5
            }
            
            // Empty current beat note values array for next beat 
            currBeatNotes = []
        }
        
        // Update tempo count
        self.tempoCount = newTempoCount
        
        // If exceeded tuner threshold for new note, update the new note
        if change {
            self.note = pitch.note
            self.cents = calulateCents(userFrequency: frequency, noteFrequency: pitch.frequency)
        }
    }
    
    func startTuner() {
        self.tuner.delegate = self
        self.tuner.start()
        self.isOn = true
    }
    
    func roundToFive(num: Double) -> Int {
        Int(5 * round(num/5))
    }
}



struct PlayMode_Previews: PreviewProvider {
    static var previews: some View {
        // Preview with example song metadata
        PlayMode(songMetadata: SongMetadata(id: -1, name: "", artist: "", resourceUrl: "", year: -1, level: -1, topScore: -1, highScore: -1, deleted: false, rank: ""), tempo: 120, timeSig: (4, 4)).previewLayout(.fixed(width: 896, height: 414))
    }
}
