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

// Posts new score to API
// Posting guidance: https://stackoverflow.com/a/58804263
func postNewScore(songId: Int, score: Int) -> () {
    // TO DO: Add user ID as non-hard-coded value
    let params: [String: String] = ["song": String(songId), "user": "1", "score": String(score)]
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

// Posts score update to API
// Posting guidance: https://stackoverflow.com/a/58804263
func postScoreUpdate(scoreId: Int, score: Int) -> () {
    // TO DO: Params from results passed into function - hard-coded right now
    let params: [String: String] = ["score": String(score)]
    let scoreUrl = URL(string: "https://practiceperfect.appspot.com/scores/" + String(scoreId))!
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

// Used for creating tranposing correspondences and plotting key signatures
let sharpOrder = ["F", "C", "G", "D", "A", "E", "B"]
let flatOrder = ["B", "E", "A", "D", "G", "C", "F"]

// Creates list of notes for transposition
func createNotesList(fifth: Int) -> Array<String> {
    let notesOrder = ["A", "B", "C", "D", "E", "F", "G"]
    let key: String = scaleOrder[fifth + 6]
    let index = notesOrder.firstIndex(of: String(key.prefix(1)))!
   
    // Get the list of notes that have accidentals in the key signature itself
    var keySigAccidentals: [String] = []
    if fifth < 0 {
        keySigAccidentals = Array<String>(sharpOrder[0 ... -fifth - 1])
    } else if fifth > 0 {
        keySigAccidentals = Array<String>(flatOrder[0 ... fifth - 1])
    }
    
    var notesList: [String] = []
    
    // End of list
    for i in index ... notesOrder.count - 1 {
        let currNote = notesOrder[i]
        // FLAT
        // If current note has an accidental in key signature
        if keySigAccidentals.contains(currNote) {
            // If already flatted, make double flat
            if fifth < 0 {
                notesList.append(currNote + "𝄫")
            // If already sharp, make natural
            } else if fifth > 0 {
                notesList.append(currNote + "♮")
            }
        // If not accidental in key signature
        } else {
            notesList.append(currNote + "♭")
        }
        
        // NOTE ITSELF
        // If current note has accidental in key signature
        if keySigAccidentals.contains(currNote) {
            // If flatted
            if fifth < 0 {
                notesList.append(currNote + "♭")
            } else if fifth > 0 {
                notesList.append(currNote + "♯")
            }
        // If not accidental in key signature
        } else {
            notesList.append(currNote)
        }
        
        // SHARP
        // If current note has accidental in key signature
        if keySigAccidentals.contains(currNote) {
            // If already flatted, make natural
            if fifth < 0 {
                notesList.append(currNote + "♮")
            // If already sharp, make double sharp
            } else if fifth > 0 {
                notesList.append(currNote + "𝄪")
            }
        // If not accidental in key signature
        } else {
            notesList.append(currNote + "♯")
        }
    }
    // Beginning of list if not already done whole list
    if (index - 1 >= 0) {
        for j in 0 ... index - 1 {
            let currNote = notesOrder[j]
            // FLAT
            // If current note has an accidental in key signature
            if keySigAccidentals.contains(currNote) {
                // If already flatted, make double flat
                if fifth < 0 {
                    notesList.append(currNote + "𝄫")
                // If already sharp, make natural
                } else if fifth > 0 {
                    notesList.append(currNote + "♮")
                }
            // If not accidental in key signature
            } else {
                notesList.append(currNote + "♭")
            }
            
            // NOTE ITSELF
            // If current note has accidental in key signature
            if keySigAccidentals.contains(currNote) {
                // If flatted
                if fifth < 0 {
                    notesList.append(currNote + "♭")
                } else if fifth > 0 {
                    notesList.append(currNote + "♯")
                }
            // If not accidental in key signature
            } else {
                notesList.append(currNote)
            }
            
            // SHARP
            // If current note has accidental in key signature
            if keySigAccidentals.contains(currNote) {
                // If already flatted, make natural
                if fifth < 0 {
                    notesList.append(currNote + "♮")
                // If already sharp, make double sharp
                } else if fifth > 0 {
                    notesList.append(currNote + "𝄪")
                }
            // If not accidental in key signature
            } else {
                notesList.append(currNote + "♯")
            }
        }
    }
    
    return notesList
}

// Used to determine which notes should be moved up or down an octave when the key is changed
let changeOctave: [Int: [String]] = [
    6: ["C", "D", "E"],
    5: ["B"],
    4: ["C", "D"],
    3: ["C", "D", "E", "F", "G"],
    2: ["C"],
    1: ["C", "D", "E", "F"],
    0: [],
    -1: ["C", "D", "E"],
    -2: ["B"],
    -3: ["C", "D"],
    -4: ["C", "D", "E", "F", "G"],
    -5: ["C"],
    -6: ["C", "D", "E", "F"]
]

// Whether notes should be moved up an octave or not (and therefore down an octave)
let changeUp: [Int: Bool] = [
    6: false,
    5: true,
    4: false,
    3: false,
    2: false,
    1: false,
    -1: false,
    -2: true,
    -3: false,
    -4: false,
    -5: false,
    -6: false
]

// Shifts notes depending on key
func transposeSong(originalMeasures: Array<MeasureMetadata>, halfStepOffset: Int) -> Array<MeasureMetadata> {
    // New list of transposed MeasureMetadata to be returned
    var transposed: Array<MeasureMetadata> = []
    
    // Get list of notes that will change octave after transpotiion
    let octChangeSet = Array<String>(changeOctave[halfStepOffset]!)
    
    // For each measure
    for i in 0...originalMeasures.count - 1 {
        let oldMeasure = originalMeasures[i]
        
        var transposeDict: [String: String] = [:]
        for (index, element) in createNotesList(fifth: oldMeasure.fifths).enumerated() {
            transposeDict[element] = createNotesList(fifth: oldMeasure.fifths - halfStepOffset)[index]
        }
        
        var newNotes: [NoteMetadata] = []
        
        // For each note in the measure
        for j in 0...oldMeasure.notes.count - 1 {
            let oldNote: NoteMetadata = oldMeasure.notes[j]
            var oldString: String = oldNote.step
            if oldNote.accidental != "" {
                oldString += oldNote.accidental
            }
            let newString: String = transposeDict[oldString]!
            let newStep: String = String(newString.prefix(1))
            
            var newAccidental: String = ""
            if newString.count > 1 {
                newAccidental = String(newString.suffix(1))
            }
            
            var octChange = false
            if octChangeSet.contains(newStep) {
                octChange = true
            }
            
            var newOctave = oldNote.octave
            if octChange {
                if octChangeSet.contains(newStep) {
                    if changeUp[halfStepOffset]! {
                        newOctave -= 1
                    } else {
                        newOctave += 1
                    }
                }
            }
                        
            let newNote: NoteMetadata = NoteMetadata(step: newStep, duration: oldNote.duration, type: oldNote.type, accidental: newAccidental,
                dot: oldNote.dot, octave: newOctave, isRest: oldNote.isRest)
            newNotes.append(newNote)
        }
        
        let newMeasure = MeasureMetadata(measureNumber: oldMeasure.measureNumber, notes: newNotes, clef: oldMeasure.clef, fifths: oldMeasure.fifths + halfStepOffset, mode: oldMeasure.mode)
        transposed.append(newMeasure)
    }
    
    return transposed
}

var testMeasures = hbdTestMeasures

// Streak multiplier values for streaks of length 0, 10, 25, and 50 (respectively)
let streakMultValues: Array<Float> = [1, 1.2, 1.5, 2]
let streakIncreases: Array<Float> = [10, 25, 50]

// For animation
let barLength = Float(screenSize.width) - Float(100)
let scrollLength = Float(screenSize.width) - Float(200)

struct PlayMode: View, TunerDelegate {
    @EnvironmentObject var settings: UserSettings
    
    // Song metadata passed from song selection - used to retrieve music data from backed through API
    var songMetadata: SongMetadata
    var tempo: Int
    var timeSig: (Int, Int)
    
    // Tuner variables
    @State var tuner = Tuner()
    @State var cents = 0.0
    @State var note = Note(Note.Name.c, Note.Accidental.natural)
    @State var isOn = false
    @State var backgroundMeanAmplitude: Float = 0.0
    @State var backgroundReadingCount: Int = 0
    
    // Tempo variables
    @State var totalElapsedBeats: Float = 0
    @State var endOfCurrentNoteBeats: Float = testMeasures[0].notes[0].duration
    
    // Countdown variables
    @State var startedPlaying = false
    
    //  Scoring variables
    @State var currBeatNotes: [Note] = [] // For all notes in current beat
    @State var runningScore: Float = 0
    @State var streakCount: Int = 0
    @State var streakValuesIndex: Int = 0
    @State var streakIncreaseIndex: Int = 0
    @State var totalNotesPlayed: Int = 0
    @State var missCount: Int = 0
    @State var goodCount: Int = 0
    @State var perfectCount: Int = 0
    
    // Note display variables
    @State var barDist = screenWidth/screenDivisions/2
    @State var currBar = 0
    @State var measures: [MeasureMetadata] = testMeasures
    @State var measureIndex = 0
    @State var beatIndex = 0
    
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
                    ZStack {
                        // draws staff
                        VStack {
                            ForEach(0 ..< 5) { index in
                                Rectangle()
                                    .frame(width: CGFloat(barLength), height: 1.0)
                                    .padding(.bottom, self.barDist)
                                    .padding(.top, 0)
                            }
                        }

                        HStack(spacing: 0) {
                            if settings.clefIndex == 0 {
                                Image("g_clef")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: self.barDist * 7)
                            } else if settings.clefIndex == 1 {
                                Image("c_clef")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: self.barDist * 6 - 7)
                                    .offset(y: CGFloat(-self.barDist / 2))
                            } else if settings.clefIndex == 2 {
                                Image("f_clef")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: self.barDist * 5)
                                    .offset(y: CGFloat(-54 + self.barDist + 10))
                            }
                            
                            self.drawKey(fifths: self.measures[self.currBar].fifths)
                            
                            ZStack {
                                Rectangle()
                                    .fill(Color.black)
                                    .frame(width: 10, height: 200)
                                    .offset(y: CGFloat(-50 / 4))
                                
                                if (self.currBar < self.measures.count - 2) {
                                    drawMeasure(msr1: self.currBar, msr2: self.currBar + 1, msr3: self.currBar + 2)
                                } else if (self.currBar < self.measures.count - 1) {
                                    drawMeasure(msr1: self.currBar, msr2: self.currBar + 1, msr3: 0)
                                } else {
                                    drawMeasure(msr1: self.currBar, msr2: 0, msr3: 1)
                                }
                                self.drawPlayLine()
                            }
                            .padding(.leading, 50)
                            
                            Spacer()
                        }
                    }

                    Spacer()
                }
                .padding(.top, 20)
                
                Spacer()

                HStack(spacing: 25) {
                    VStack(spacing: 1) {
                        if (displayNote(note: note) == measures[measureIndex].notes[beatIndex].step + measures[measureIndex].notes[beatIndex].accidental) {
                            Text(displayNote(note: note))
                            .foregroundColor(.green)
                            .modifier(NoteNameStyle())
                            .frame(minWidth: 175, maxWidth: 175, maxHeight: 75)
                        } else if (displayNote(note: note.halfStepUp) == measures[measureIndex].notes[beatIndex].step + measures[measureIndex].notes[beatIndex].accidental) {
                            Text(displayNote(note: note))
                            .foregroundColor(.yellow)
                            .modifier(NoteNameStyle())
                            .frame(minWidth: 175, maxWidth: 175, maxHeight: 75)
                        } else if (displayNote(note: note.halfStepDown) == measures[measureIndex].notes[beatIndex].step + measures[measureIndex].notes[beatIndex].accidental) {
                            Text(displayNote(note: note))
                            .foregroundColor(.yellow)
                            .modifier(NoteNameStyle())
                            .frame(minWidth: 175, maxWidth: 175, maxHeight: 75)
                        } else if (displayNote(note: note.wholeStepUp) == measures[measureIndex].notes[beatIndex].step + measures[measureIndex].notes[beatIndex].accidental) {
                            Text(displayNote(note: note))
                            .foregroundColor(.yellow)
                            .modifier(NoteNameStyle())
                            .frame(minWidth: 175, maxWidth: 175, maxHeight: 75)
                        } else if (displayNote(note: note.wholeStepDown) == measures[measureIndex].notes[beatIndex].step + measures[measureIndex].notes[beatIndex].accidental) {
                            Text(displayNote(note: note))
                            .foregroundColor(.yellow)
                            .modifier(NoteNameStyle())
                            .frame(minWidth: 175, maxWidth: 175, maxHeight: 75)
                        } else {
                            Text(displayNote(note: note))
                            .foregroundColor(.red)
                            .modifier(NoteNameStyle())
                            .frame(minWidth: 175, maxWidth: 175, maxHeight: 75)
                        }
                        
                        if cents > 0 {
                            Text("\(roundToFive(num: cents)) cents sharp")
                        } else if cents < 0 {
                            Text("\(roundToFive(num: abs(cents))) cents flat")
                        } else {
                            Text("In tune!")
                        }
                    }
                        .font(Font.body.weight(.bold))
                        .frame(maxWidth: 125, maxHeight: 150)
                    
                    if isOn {
                        Button(action: {
                            self.tuner.stop()
                            self.isOn = false
                        }) {
                            Text("Pause")
                        }
                             .modifier(MenuButtonStyle())
                        .frame(width: 125)
                    } else if startedPlaying {
                        Button(action: {
                            self.startTuner()
                        }) {
                            Text("Resume")
                        }
                             .modifier(MenuButtonStyle())
                    } else {
                        Button(action: {
                            self.startTuner()
                            self.startedPlaying = true
                        }) {
                            Text("START")
                        }
                             .modifier(MenuButtonStyleRed())
                    }
                                                            
                    Text("Score:")
                        .font(Font.title.weight(.bold))
                    Text(String(Int(runningScore)))
                        .font(Font.largeTitle.weight(.bold))
                        .frame(width: 150)
                                        
                    NavigationLink(destination: ResultsPage(scoreMetadata: ScoreMetadata(newScore: Int(self.runningScore), inTuneCount: 0, inTempoCount: 0, perfectCount: self.perfectCount, goodCount: self.goodCount, missCount: self.missCount, totalCount: self.totalNotesPlayed), songMetadata: songMetadata)) {
                        Text("Results")
                    }
                        .simultaneousGesture(TapGesture().onEnded {
                            // TO DO: Right now, sends new high score to server when pause button is pressed. This will need to be updated
                            self.tuner.stop()
                            // If highScoreId of -1, i.e. no existing score, then create; otherwise update
                            if self.songMetadata.highScoreId == -1 {
                                postNewScore(songId: self.songMetadata.songId, score: Int(self.runningScore))
                            } else {
                                if (Int(self.runningScore) > self.songMetadata.highScore) {
                                    postScoreUpdate(scoreId: self.songMetadata.highScoreId, score: Int(self.runningScore))
                                }
                            }
                        })
                        .modifier(MenuButtonStyle())
                        .frame(width: 125)
                }
            }
        }
        .foregroundColor(.black)
        .navigationBarTitle("You are playing: " + songMetadata.name)
        .onAppear {
            self.getXML()
            if self.settings.keyIndex - 6 != 0 {
                self.measures = transposeSong(originalMeasures: self.measures, halfStepOffset: self.settings.keyIndex - 6)
            }
        }
        .onDisappear(perform: self.tuner.stop)
    }
    
    // If correct note, then 10 points; if one half step away, then 5 points; if one whole step away, then 3 points; increase streak count for target, neutral for half step off, reset for whole note or worse
    func updateScore(value: Note) {
        totalNotesPlayed += 1
        switch measures[measureIndex].notes[beatIndex].step + measures[measureIndex].notes[beatIndex].accidental {
        case displayNote(note: value):
            perfectCount += 1
            streakCount += 1
            if streakIncreases.contains(Float(streakCount)) {
                streakValuesIndex += 1
            }
            runningScore += (10 * streakMultValues[streakValuesIndex])
        case displayNote(note: value.halfStepUp), displayNote(note: value.halfStepDown):
            goodCount += 1
            runningScore += (5 * streakMultValues[streakValuesIndex])
        case displayNote(note: value.wholeStepUp), displayNote(note: value.wholeStepDown):
            goodCount += 1
            streakCount = 0
            streakValuesIndex = 0
            runningScore += 3
        default:
            missCount += 1
            streakCount = 0
            streakValuesIndex = 0
        }
    }

    // Updates current note information from microphone
    func tunerDidTick(pitch: Pitch, frequency: Double, beatCount: Int, change: Bool) {
        // Convert beatCount to seconds by multiplying by sampling rate, then to minutes by dividing by 60. Then multiply by tempo (bpm) to get tempo count
        let newElapsedBeats: Float = Float(beatCount) * Float(tuner.pollingInterval) / Float(60) * Float(tempo)
         
        // If still in the countdown, take readings to calculate background noise and update threshold
        if !(Int(newElapsedBeats) > timeSig.0) {
            backgroundReadingCount += 1
            backgroundMeanAmplitude = (Float(backgroundReadingCount - 1) * backgroundMeanAmplitude + Float(tuner.tracker.amplitude)) / Float(backgroundReadingCount)
            tuner.updateThreshold(newThreshold: backgroundMeanAmplitude)
        }
                        
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
            
            // If on last beat of current measure, go to first beat
            if beatIndex == measures[measureIndex].notes.count - 1 {
                beatIndex = 0
                // If finishing last measure, go back to first measure
                if measureIndex == measures.count - 1 {
                    measureIndex = 0
                } else {
                    measureIndex += 1
                }
            } else {
                beatIndex += 1
            }
                        
            endOfCurrentNoteBeats = endOfCurrentNoteBeats + measures[measureIndex].notes[beatIndex].duration
        }
        
        // Keep track of current bar
        if Int(newElapsedBeats) > Int(self.totalElapsedBeats) && Int(newElapsedBeats) % timeSig.0 == 0 &&
           Int(newElapsedBeats) != 0 {
            self.currBar += 1
        }
        
        // temp safety
        if self.currBar >= testMeasures.count {
            self.currBar = 0
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
    
    // Used to determine which octave the key signature accidentals should be in
    func determineOctave(text: String, index: Int, keys: [String]) -> some View {
        if !keys.contains(sharpOrder[index]) {
            return Group {
                Text(text).modifier(KeyStyle(offset: self.calcNoteOffset(note: sharpOrder[index], octave: 5)))
            }
        } else {
            return Group {
                Text(text).modifier(KeyStyle(offset: self.calcNoteOffset(note: sharpOrder[index], octave: 4)))
            }
        }
    }
    
    func drawKey(fifths: Int) -> some View {
        return Group {
            if fifths > 0 {
                ForEach(0 ..< fifths, id: \.self) { index in
                    self.determineOctave(text: "♯", index: index, keys: ["A", "B"])
                }
            } else if fifths < 0 {
                ForEach((7 + fifths ..< 7).reversed(), id: \.self) { index in
                    self.determineOctave(text: "♭", index: index, keys: ["A", "B", "G"])
                }
            }
        }
    }
    
    func calcOpacity(scrollOffset: Float) -> Double {
        let opacityRange = Float(50)
        let keySigOffset = Float(Double(measures[measureIndex].fifths) * 20.0)
        let scrollDiff = barLength - scrollLength
        var opacity: Double = 0
        if scrollOffset > scrollLength - opacityRange - keySigOffset {
            opacity = 0
        } else if scrollOffset > scrollLength - scrollDiff - keySigOffset {
            opacity = Double(1) - Double((scrollOffset - scrollLength + scrollDiff + keySigOffset) / opacityRange)
        } else if scrollOffset >= 0 {
            opacity = 1
        } else if scrollOffset >= -opacityRange {
            opacity = Double(1) - Double(scrollOffset / -opacityRange)
        }
        
        return opacity
    }
    
    func drawNote(note: NoteMetadata, barIndex: Int, barNumber: Int) -> some View {
        let offset = self.calcNoteOffset(note: note.step, octave: note.octave)
         
        // Get offset between each pair of notes
        let index = self.measures[barIndex].notes.firstIndex(of: note)
        var beatOffset: Float = 0
        if index! > 0 {
            for i in 1...index!{
                beatOffset += self.measures[barIndex].notes[i - 1].duration
            }
        }
        
        // For flag animation calculation
        var prevSame: Bool = false
        if index! > 0 {
            if (self.measures[barIndex].notes[index! - 1].type == note.type) && (!self.measures[barIndex].notes[index! - 1].isRest) {
                prevSame = true
            }
        }
        var followingSame: Int = 0
        var breakReached: Bool = false
        if (note.type == "eighth")  {
            if index! < self.measures[barIndex].notes.count - 1 {
                if self.measures[barIndex].notes[index! + 1].type == note.type {
                    if !self.measures[barIndex].notes[index! + 1].isRest {
                        followingSame += 1
                    }
                }
            }
        } else if (note.type == "16th") {
            if index! < self.measures[barIndex].notes.count - 1 {
                for i in index! + 1 ... self.measures[barIndex].notes.count - 1 {
                    if !breakReached {
                        if self.measures[barIndex].notes[i].type == note.type {
                            if !self.measures[barIndex].notes[i].isRest {
                                followingSame += 1
                                if followingSame == 3 {
                                    breakReached = true
                                }
                            } else {
                                breakReached = true
                            }
                        } else {
                            breakReached = true
                        }
                    }
                }
            }
        }

        // Calculate x position of note
        let barBeatDiv: Float = scrollLength / Float(self.timeSig.0)
        let beat = Int(self.totalElapsedBeats) % self.timeSig.0 + 1
        let beatDiff = self.totalElapsedBeats - Float(Int(self.totalElapsedBeats))
        let scrollOffset = barBeatDiv + (barBeatDiv * Float(beatOffset)) - Float(barBeatDiv * (Float(beat) + beatDiff)) + (Float(barNumber) * scrollLength)
        
        let opacity = calcOpacity(scrollOffset: scrollOffset)
        
        let facingUp = offset > Int(self.barDist + 10) * 2
        
        let aboveStaff = [Int(self.barDist + 10) * -1, Int(self.barDist + 10) * -2, Int(self.barDist + 10) * -3, Int(self.barDist + 10) * -4, Int(self.barDist + 10) * -5]
        let belowStaff = [Int(self.barDist + 10) * 5, Int(self.barDist + 10) * 6, Int(self.barDist + 10) * 7, Int(self.barDist + 10) * 8, Int(self.barDist + 10) * 9]
        
        var ledgerLines: [Int] {
            if note.octave > 4 {
                return aboveStaff.filter { $0 >= offset }
            } else {
                return belowStaff.filter { $0 <= offset }
            }
        }
        
        var keySigAccidentals: [String] = []
        let fifths = self.measures[self.measureIndex].fifths
        if fifths > 0 {
            keySigAccidentals = Array<String>(sharpOrder[0 ... fifths - 1])
        } else if fifths < 0 {
            keySigAccidentals = Array<String>(flatOrder[0 ... -fifths - 1])
        }
        
        let eighthFlagLength: Double = Double(barBeatDiv / 2)
        let sixteenthFlagLength: Double = Double(barBeatDiv / 4) * Double(followingSame)
        
        return Group {
            if note.isRest {  
                if note.type == "16th" {
                    Image("16th_rest")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: self.barDist * 2)
                        .modifier(RestStyle(offset: Int((self.barDist + 10) * 2), scrollOffset: scrollOffset, opacity: opacity))
                }
                else if note.type == "eighth" {
                    Image("eighth_rest")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: self.barDist * 2)
                        .modifier(RestStyle(offset: Int((self.barDist + 10) * 2), scrollOffset: scrollOffset, opacity: opacity))
                }
                else if note.type == "quarter" {
                    Image("crotchet_rest")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: self.barDist * 4)
                        .modifier(RestStyle(offset: Int((self.barDist + 10) * 2), scrollOffset: scrollOffset, opacity: opacity))
                }
                else if note.type == "half" {
                    Rectangle()
                        .frame(width: 25.0, height: self.barDist / 2)
                        .offset(x: CGFloat(scrollOffset), y: -75 + CGFloat(Int(self.barDist * 2.5)))
                        .opacity(opacity)
                }
                else if note.type == "whole" {
                    Rectangle()
                        .frame(width: 25.0, height: self.barDist / 2)
                        .offset(x: CGFloat(scrollOffset), y: -75 + CGFloat(Int(self.barDist * 1.75)))
                        .opacity(opacity)
                }
                else {
                    Rectangle()
                        .frame(width: 25.0, height: self.barDist / 2)
                        .offset(x: CGFloat(scrollOffset), y: -75 + CGFloat(Int(self.barDist * 1.75)))
                        .opacity(opacity)
                }
            } else {
                ForEach(ledgerLines, id: \.self) { line in
                    Rectangle()
                    .modifier(LedgerStyle(offset: line, scrollOffset: scrollOffset, opacity: opacity))
                }
                
                if (note.accidental == "♯") && (!keySigAccidentals.contains(note.step)) {
                    Text("♯").modifier(AccidentalScrollStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity))
                }
                if (note.accidental == "♭") && (!keySigAccidentals.contains(note.step)) {
                    Text("♭").modifier(AccidentalScrollStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity))
                }
                if note.accidental == "♮" {
                    Text("♮").modifier(AccidentalScrollStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity))
                }
                if note.accidental == "𝄪" {
                    Text("𝄪").modifier(AccidentalScrollStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity))
                }
                if note.accidental == "𝄫" {
                    Text("𝄫").modifier(AccidentalScrollStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity))
                }
                
                if note.type == "16th" {
                    Circle()
                        .frame(width: 34.0, height: 34.0)
                        .modifier(NoteStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity))
                    Rectangle()
                        .modifier(TailStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity, facingUp: facingUp))
                    if (followingSame >= 1) && (!prevSame){
                        Rectangle()
                            .modifier(FlagStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity, facingUp: facingUp, position: 0, givenWidth: sixteenthFlagLength))
                        Rectangle()
                            .modifier(FlagStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity, facingUp: facingUp, position: 1, givenWidth: sixteenthFlagLength))
                    } else if !prevSame {
                        Rectangle()
                            .modifier(FlagStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity, facingUp: facingUp, position: 0, givenWidth: -1))
                        Rectangle()
                            .modifier(FlagStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity, facingUp: facingUp, position: 1, givenWidth: -1))
                    }
                }
                else if note.type == "eighth" {
                    Circle()
                        .frame(width: 34.0, height: 34.0)
                        .modifier(NoteStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity))
                    Rectangle()
                        .modifier(TailStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity, facingUp: facingUp))
                    
                    if (followingSame >= 1) && (!prevSame) {
                        Rectangle()
                            .modifier(FlagStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity, facingUp: facingUp, position: 0, givenWidth: eighthFlagLength))
                    } else if !prevSame {
                        Rectangle()
                            .modifier(FlagStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity, facingUp: facingUp, position: 0, givenWidth: -1))
                    }
                }
                else if note.type == "quarter" {
                    Circle()
                        .frame(width: 34.0, height: 34.0)
                        .modifier(NoteStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity))
                    Rectangle()
                        .modifier(TailStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity, facingUp: facingUp))
                }
                else if note.type == "half" {
                    Circle()
                        .stroke(Color.black, lineWidth: 4)
                        .modifier(NoteStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity))
                    Rectangle()
                        .modifier(TailStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity, facingUp: facingUp))
                }
                else if note.type == "whole" {
                    Circle()
                        .stroke(Color.black, lineWidth: 4)
                        .modifier(NoteStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity))
                }
                else {
                    Circle()
                        .modifier(NoteStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity))
                    Rectangle()
                        .modifier(TailStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity, facingUp: facingUp))
                }
            }
            
            if note.dot {
                Circle()
                    .modifier(NoteDotStyle(offset: offset, scrollOffset: 40 + scrollOffset, opacity: opacity))
            }
        }
    }
    
    func drawMeasure(msr1: Int, msr2: Int, msr3: Int) -> some View {
        return Group {
            ForEach(self.measures[msr1].notes) { note in
                self.drawNote(note: note, barIndex: msr1, barNumber: 0)
            }
            self.drawMeasureBar(barNumber: 0)
            ForEach(self.measures[msr2].notes) { note in
                self.drawNote(note: note, barIndex: msr2, barNumber: 1)
            }
            self.drawMeasureBar(barNumber: 1)
            ForEach(self.measures[msr3].notes) { note in
                self.drawNote(note: note, barIndex: msr3, barNumber: 2)
            }
        }
    }
    
    func drawMeasureBar(barNumber: Int) -> some View {
        let barBeatDiv: Float = scrollLength / Float(self.timeSig.0)
        let beat = Int(self.totalElapsedBeats) % self.timeSig.0 + 1
        let beatDiff = self.totalElapsedBeats - Float(Int(self.totalElapsedBeats))
        let scrollOffset = scrollLength + (barBeatDiv * 0.875) - Float(barBeatDiv * (Float(beat) + beatDiff)) + (Float(barNumber) * scrollLength)
        
        let opacity = calcOpacity(scrollOffset: scrollOffset)
        
        return Group {
            Rectangle()
                .fill(Color.black)
                .frame(width: 5, height: 126)
                .offset(x: CGFloat(scrollOffset), y: CGFloat(-11))
                .opacity(opacity)
        }
    }
    
    func drawPlayLine() -> some View {
        let currNote = self.measures[measureIndex].notes[beatIndex]
        let offset = self.calcNoteOffset(note: currNote.step, octave: currNote.octave)
        let fullLength: Float = (scrollLength / Float(timeSig.0)) * currNote.duration
        let remainingRatio: Float = (endOfCurrentNoteBeats - totalElapsedBeats) / currNote.duration
        let remainingLength: Float = fullLength * remainingRatio - 25
        var opacity: Double = 1
        
        if remainingLength < 0 {
            opacity = 0
        }
        
        if currNote.isRest {
            opacity = 0
        }
        
        let colorIndex: Int = feedbackColor(value: note)
        
        if colorIndex == 2 {
            return Group {
                Rectangle()
                    .fill(Color.red)
                    .opacity(opacity)
                    .frame(width: CGFloat(remainingLength), height: 5)
                    .offset(x: CGFloat(remainingLength / 2), y: CGFloat(-75 + offset))
                    .frame(width: 0)
            }
        } else if colorIndex == 1 {
            return Group {
                Rectangle()
                    .fill(Color.yellow)
                    .opacity(opacity)
                    .frame(width: CGFloat(remainingLength), height: 5)
                    .offset(x: CGFloat(remainingLength / 2), y: CGFloat(-75 + offset))
                    .frame(width: 0)
            }
        } else {
            return Group {
                Rectangle()
                    .fill(Color.green)
                    .opacity(opacity)
                    .frame(width: CGFloat(remainingLength), height: 5)
                    .offset(x: CGFloat(remainingLength / 2), y: CGFloat(-75 + offset))
                    .frame(width: 0)
            }
        }
    }
    
    func feedbackColor(value: Note) -> Int {
        switch measures[measureIndex].notes[beatIndex].step + measures[measureIndex].notes[beatIndex].accidental {
        case displayNote(note: value):
            return 0
        case displayNote(note: value.halfStepUp), displayNote(note: value.halfStepDown):
            return 1
        case displayNote(note: value.wholeStepUp), displayNote(note: value.wholeStepDown):
            return 1
        default:
            return 2
        }
    }
    
    func calcNoteOffset(note: String, octave: Int = 4) -> Int {
        let base = Float(self.barDist + 10)
        var offset: Float
        switch note {
            case "C":
                offset = 5
            case "D":
                offset = 4.5
            case "E":
                offset = 4
            case "F":
                offset = 3.5
            case "G":
                offset = 3
            case "A":
                offset = 2.5
            case "B":
                offset = 2
            default:
                offset = 5
        }
        
        if settings.clefIndex == 0 {
            offset += 3.5 * Float(4 - octave)
        } else if settings.clefIndex == 1 {
            offset += 3.5 * Float(4 - (octave - 1))
            offset -= 3
        } else if settings.clefIndex == 2 {
            offset += 3.5 * Float(4 - (octave - 2))
            offset -= 6
        }
        
        return Int(base * offset)
    }
}



struct PlayMode_Previews: PreviewProvider {
    static var previews: some View {
        // Preview with example song metadata
        PlayMode(songMetadata: SongMetadata(songId: -1, name: "", artist: "", resourceUrl: "", year: -1, level: -1, topScore: -1, highScore: -1, highScoreId: -1, deleted: false, rank: ""), tempo: 120, timeSig: (4, 4)).previewLayout(.fixed(width: 896, height: 414))
    }
}
