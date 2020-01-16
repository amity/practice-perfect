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
var musicXMLToParseFromFile: String = loadXML2String(fileName: "apres", fileExtension: "musicxml")

// Posts result score to update backend
// TO DO: Update parameters to include user id, song id, and score
func postSongs() -> () {
    // TO DO: Params from results passed into function - hard-coded right now
    let params: [String: String] = ["song": "12", "user": "3", "score": "240"]
    let scoreUrl = URL(string: "https://practiceperfect.appspot.com/scores")!
    let scoreSession = URLSession.shared
    var scoreRequest = URLRequest(url: scoreUrl)
    scoreRequest.httpMethod = "POST"
    scoreRequest.httpBody = try? JSONSerialization.data(withJSONObject: params)
    scoreRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
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

func createTestData () -> [NoteMetadata] {
    // Test data - to be removed when parsing XML is done
    let note1 = NoteMetadata()
    note1.duration = 1
    note1.step = "C"
    let note2 = NoteMetadata()
    note2.duration = 1
    note2.step = "D"
    let note3 = NoteMetadata()
    note3.duration = 1
    note3.step = "E"
    let note4 = NoteMetadata()
    note4.duration = 1
    note4.step = "F"
    let note5 = NoteMetadata()
    note5.duration = 1
    note5.step = "G"
    let note6 = NoteMetadata()
    note6.duration = 1
    note6.step = "A"
    let note7 = NoteMetadata()
    note7.duration = 1
    note7.step = "B"
    let note8 = NoteMetadata()
    note8.duration = 1
    note8.step = "C"
    
    return [note1, note2, note3, note4, note5, note6, note7, note8]
}

// Star multiplier values for 1 through 5 stars (at indices 0 through 4)
let starMultValues: Array<Float> = [1, 1.5, 2.5, 4.5, 8.5]
// Streak multiplier values for streaks of length 0, 10, 25, and 50 (respectively)
//let streakMultValues: Array<Float> = [1, 1.2, 1.5, 2]
let streakMultValues: Array<Float> = [1, 2, 3, 4] // Simpler values for testing
let streakIncreases: Array<Float> = [10, 25, 50]

struct PlayMode: View, TunerDelegate {
    // Song metadata passed from song selection - used to retrieve music data from backed through API
    var songMetadata: SongMetadata
    var tempo: Int
    var timeSig: (Int, Int)
    
    // UNUSED SCORING PARAMETERS
    // Total score: running count, @State displayed to the user
    @State var totalScore: Float = 0
    // Star multiplier: more difficult songs get you more points overall
    lazy var starMult: Float = starMultValues[songMetadata.level]

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
    @State var totalElapsedBeats: Float = 0
    @State var endOfCurrentNoteBeats: Float = 1 // TO-DO: have this not be hardcoded
    @State var testNotes: [NoteMetadata] = createTestData()
    @State var testNotesIndex = 0
    
    // Countdown variables
    @State var showCountdown = true
    let beats = 4
    
    //  Scoring variables
    @State var currBeatNotes: [Note] = [] // For all notes in current beat
    @State var runningScore: Float = 0
    @State var streakCount: Int = 0
    @State var streakValuesIndex: Int = 0
    
    // Note display variables
    @State var barDist = screenWidth/screenDivisions/2
    @State var currBar = 0
    
    // File retrieval methods adapted from:
    // https://www.raywenderlich.com/3244963-urlsession-tutorial-getting-started
    private func getXML() {
        dataTask?.cancel()
        
        if var urlComponents = URLComponents(string: songMetadata.resourceUrl) {
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
                    self.XMLString = String(data: data, encoding: .utf8) ?? ""
                    print(self.XMLString)
                    print(self.songMetadata.resourceUrl)
                }
            }
            dataTask?.resume()
        }
    }
    
    // XML Retrieval
    @State var downloadSession = URLSession(configuration: .default)
    @State var dataTask: URLSessionDataTask?
    @State var errorMessage = ""
    @State var results = ""
    @State var XMLString = ""
    
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
                        Text(String(Int(totalElapsedBeats) % timeSig.0 + 1))
                            .font(Font.system(size:64).weight(.bold))
                        Text("Target: " + String(testNotes[testNotesIndex].step))
                            .font(Font.system(size:64).weight(.bold))
                    }
                        .font(Font.system(size: 16).weight(.bold))

                    Spacer()
                    
                    ZStack {
                        // draws staff
                        VStack {
                            ForEach(0 ..< 5) { index in
                                Rectangle()
                                    .frame(width: 500.0, height: 1.0)
                                    .padding(.bottom, self.barDist)
                                    .padding(.top, 0)
                            }
                        }
                        
                        // draws notes
                        HStack {
                            ForEach(0 ..< 4) { index in
                                Circle()
                                    .frame(width: 30.0, height: 30.0)
                                    .padding(.trailing, 10)
                                    .offset(x: CGFloat(-100), y: CGFloat(-75 + self.calcNoteOffset(note: self.testNotes[self.currBar * self.timeSig.0 + index])))
                            }
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

//                        // If high score of 0, i.e. no existing score
//                        if songMetadata.highScore == 0 {
//                            postSongs()
//                        }
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
        .navigationBarTitle("You are playing: " + songMetadata.name)
        .onAppear {
            self.getXML()
        }
        .onDisappear(perform: self.tuner.stop)
    }
    
    // If correct note, then 10 points; if one half step away, then 5 points; if one whole step away, then 3 points; increase streak count for target, neutral for half step off, reset for whole note or worse
    func updateScore(value: Note) {
        switch testNotes[testNotesIndex].step {
        case displayNote(note: value):
            streakCount += 1
            if streakIncreases.contains(Float(streakCount)) {
                streakValuesIndex += 1
            }
            runningScore += (10 * streakMultValues[streakValuesIndex])
        case displayNote(note: value.halfStepUp), displayNote(note: value.halfStepDown):
            runningScore += (5 * streakMultValues[streakValuesIndex])
        case displayNote(note: value.wholeStepUp), displayNote(note: value.wholeStepDown):
            streakCount = 0
            streakValuesIndex = 0
            runningScore += 3
        default:
            streakCount = 0
            streakValuesIndex = 0
        }
    }

    // Updates current note information from microphone
    func tunerDidTick(pitch: Pitch, frequency: Double, beatCount: Int, change: Bool) {
        // Convert beatCount to seconds by multiplying by sampling rate, then to minutes by dividing by 60. Then multiply by tempo (bpm) to get tempo count
        let newElapsedBeats: Float = Float(beatCount) * Float(0.05) / Float(60) * Float(tempo)
        
        // If still on current note, add pitch reading to array
        if newElapsedBeats <= endOfCurrentNoteBeats {
            currBeatNotes.append(pitch.note)
        }
        // If new beat, calculate score and empty list for next beat
        else {
            // Frequency calculation algorithm from: https://stackoverflow.com/questions/38416347/getting-the-most-frequent-value-of-an-array
            
            // Create dictionary to map value to count and get most frequent note
            var counts = [Note: Int]()
            currBeatNotes.forEach { counts[$0] = (counts[$0] ?? 0) + 1 }
            let (value, _) = counts.max(by: {$0.1 < $1.1}) ?? (Note(Note.Name(rawValue: 0)!,Note.Accidental(rawValue: 0)!), 0)
            
            updateScore(value: value)
            
            // Empty current beat note values array for next beat 
            currBeatNotes = []
            
            // Go to next note in array
            if testNotesIndex == testNotes.count - 1 {
                testNotesIndex = 0
            } else {
                testNotesIndex += 1
            }
            
            endOfCurrentNoteBeats = totalElapsedBeats + testNotes[testNotesIndex].duration
            
            // Keep track of current bar
            if Int(totalElapsedBeats) % timeSig.0 == 0 {
                self.currBar += 1
            }
            
            // temp safety
            if (self.currBar + 1) * timeSig.0 > testNotes.count {
                self.currBar = 0
            }
            
        }
        
        // Update tempo count
        self.totalElapsedBeats = newElapsedBeats
        
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
    
    func calcNoteOffset(note: NoteMetadata) -> Int {
        var offset = self.barDist + 10
        switch note.step {
            case "F":
                offset *= 0
            case "E":
                offset *= 0.5
            case "D":
                offset *= 1
            case "C":
                offset *= 1.5
            case "B":
                offset *= 2
            case "A":
                offset *= 2.5
            case "G":
                offset *= 3
            default:
                offset *= 3.5
        }
        
        return Int(offset)
    }
}



struct PlayMode_Previews: PreviewProvider {
    static var previews: some View {
        // Preview with example song metadata
        PlayMode(songMetadata: SongMetadata(id: -1, name: "", artist: "", resourceUrl: "", year: -1, level: -1, topScore: -1, highScore: -1, deleted: false, rank: ""), tempo: 120, timeSig: (4, 4)).previewLayout(.fixed(width: 896, height: 414))
    }
}
