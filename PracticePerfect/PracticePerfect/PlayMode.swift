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

// Streak multiplier values for streaks of length 0, 10, 25, and 50 (respectively)
let streakMultValues: Array<Float> = [1, 1.2, 1.5, 2]
let streakIncreases: Array<Float> = [10, 25, 50]

// For animation
let barLength = Float(screenSize.width) - Float(100)
let scrollLength = Float(screenSize.width) - Float(200)

// Used for creating tranposing correspondences and plotting key signatures
let sharpOrder = ["F", "C", "G", "D", "A", "E", "B"]
let flatOrder = ["B", "E", "A", "D", "G", "C", "F"]

struct PlayMode: View, TunerDelegate {
    @EnvironmentObject var settings: UserSettings
    @Binding var rootIsActive : Bool
    @State var timePassed: Double = 0
    
    // Song metadata passed from song selection - used to retrieve music data from backed through API
    var songMetadata: SongMetadata
    var tempo: Int
    @State var isSong: Bool
    
    // Tuner variables
    @State var tuner: Tuner
    @State var cents = 0.0
    @State var note = Note(Note.Name.c, Note.Accidental.natural)
    @State var isOn = false
    
    // Tempo variables
    @State var totalElapsedBeats: Float = 0
    @State var endOfCurrentNoteBeats: Float = 1
    
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
    
    // Start with placeholder measure
    @State var measures: [MeasureMetadata] = [MeasureMetadata(measureNumber: 1, notes: [NoteMetadata(step: "C")])]
    @State var xmlString: String
    
    //original hard-coded HBD test measures
    //@State var measures: [MeasureMetadata] = hbdTestMeasures
    @State var beatIndex = 0
    @State var measureBeat = 0
    
    // Restart and rewind variables
    @State var isOver = false
    @State var rewound = false
    
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
                            
                            
                            self.drawKey(fifths: self.measures[Int(min(self.currBar, self.measures.count - 1))].fifths)
                            
                            ZStack {
                                Rectangle()
                                    .fill(Color.black)
                                    .frame(width: 10, height: 200)
                                    .offset(y: CGFloat(-50 / 4))
                                
                                drawMeasure(msr: self.currBar)
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
                        if (displayNote(note: note) == measures[currBar].notes[beatIndex].step + measures[currBar].notes[beatIndex].accidental) {
                            Text(displayNote(note: note))
                            .foregroundColor(.green)
                            .modifier(NoteNameStyle())
                            .frame(minWidth: 175, maxWidth: 175, maxHeight: 75)
                        } else if (displayNote(note: note.halfStepUp) == measures[currBar].notes[beatIndex].step + measures[currBar].notes[beatIndex].accidental) {
                            Text(displayNote(note: note))
                            .foregroundColor(.yellow)
                            .modifier(NoteNameStyle())
                            .frame(minWidth: 175, maxWidth: 175, maxHeight: 75)
                        } else if (displayNote(note: note.halfStepDown) == measures[currBar].notes[beatIndex].step + measures[currBar].notes[beatIndex].accidental) {
                            Text(displayNote(note: note))
                            .foregroundColor(.yellow)
                            .modifier(NoteNameStyle())
                            .frame(minWidth: 175, maxWidth: 175, maxHeight: 75)
                        } else if (displayNote(note: note.wholeStepUp) == measures[currBar].notes[beatIndex].step + measures[currBar].notes[beatIndex].accidental) {
                            Text(displayNote(note: note))
                            .foregroundColor(.yellow)
                            .modifier(NoteNameStyle())
                            .frame(minWidth: 175, maxWidth: 175, maxHeight: 75)
                        } else if (displayNote(note: note.wholeStepDown) == measures[currBar].notes[beatIndex].step + measures[currBar].notes[beatIndex].accidental) {
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
                    
                    if isOver {
                        Button(action: {
                            // Tempo variables
                            self.endOfCurrentNoteBeats += hbdTestMeasures[0].notes[0].duration - 1
                            
                            // Countdown variables
                            self.startedPlaying = false
                            
                            //  Scoring variables
                            self.currBeatNotes = [] // For all notes in current beat
                            self.runningScore = 0
                            self.streakCount = 0
                            self.streakValuesIndex = 0
                            self.streakIncreaseIndex = 0
                            self.totalNotesPlayed = 0
                            self.missCount = 0
                            self.goodCount = 0
                            self.perfectCount = 0
                            
                            // Note display variables
                            self.currBar = 0
                            self.beatIndex = 0
                            self.measureBeat = 0
                            
                            self.isOver = false
                        }) {
                            Image(systemName: "backward.end.alt.fill")
                            .frame(width: 50)
                        }
                             .modifier(MenuButtonStyleRed())
                    } else if isOn {
                        Button(action: {
                            self.tuner.stop()
                            self.isOn = false
                        }) {
                            Image(systemName: "pause.fill")
                            .frame(width: 50)
                        }
                             .modifier(MenuButtonStyle())
                    } else if startedPlaying {
                        Button(action: {
                            self.startTuner()
                        }) {
                            Image(systemName: "play.fill")
                            .frame(width: 50)
                        }
                             .modifier(MenuButtonStyle())
                    } else {
                        Button(action: {
                            self.startTuner()
                            self.startedPlaying = true
                        }) {
                            Image(systemName: "play.fill")
                            .frame(width: 50)
                        }
                             .modifier(MenuButtonStyleRed())
                    }
                    VStack {
                        HStack {
                            Text("Score:")
                                .font(Font.title.weight(.bold))
                            Text(String(Int(runningScore)))
                                .font(Font.largeTitle.weight(.bold))
                                .frame(width: 150)
                        }
                        Text("Measure: " + String(Int(min(currBar, measures.count - 1))) + " / " + String(Int(measures.count) - 1))
                    }
                    
                    Button(action: {
                        self.isOver = false
                        self.currBar = max(0, self.currBar - 1)
                        self.beatIndex = 0
                        self.measureBeat = 0
                        self.endOfCurrentNoteBeats = ceil(self.endOfCurrentNoteBeats) + self.measures[self.currBar].notes[0].duration - 1
                        self.rewound = true
                    }) {
                        Image(systemName: "gobackward")
                        .frame(width: 50)
                    }
                         .modifier(MenuButtonStyle())
                        .disabled(self.rewound)
                        .opacity(self.rewound ? 0.5 : 1)

                    NavigationLink(destination: ResultsPage(shouldPopToRootView: self.$rootIsActive, scoreMetadata: ScoreMetadata(newScore: Int(self.runningScore), inTuneCount: 0, inTempoCount: 0, perfectCount: self.perfectCount, goodCount: self.goodCount, missCount: self.missCount, totalCount: self.totalNotesPlayed), songMetadata: songMetadata, showPrevious: self.isSong)) {
                        Text("Results")
                    }
                        .isDetailLink(false)
                        .simultaneousGesture(TapGesture().onEnded {
                            // TO DO: Right now, sends new high score to server when pause button is pressed. This will need to be updated
                            self.tuner.stop()
                            // If highScoreId of -1, i.e. no existing score, then create; otherwise update
                            if self.songMetadata.highScoreId == -1 {
                                postNewScore(userId: self.settings.userId, songId: self.songMetadata.songId, score: Int(self.runningScore))
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
            // If is a song
            if self.isSong {
                self.measures = parseMusicXML(isSong: true, xmlString: self.xmlString).measures
            // If is a scale/arpeggio
            } else {
                self.measures = parseMusicXML(isSong: false, xmlString: self.xmlString).measures
            }
            
            // Adjust for key of instrument if not an exercise
            if self.isSong && self.settings.keyIndex - 6 != 0 {
                self.measures = transposeSong(originalMeasures: self.measures, halfStepOffset: self.settings.keyIndex - 6)
            }
        }
        .onDisappear() {
            // Stop tuner when navigating away from page 
            self.tuner.stop()
            
            // Get current date
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let dateString = formatter.string(from: Date())
            
            // Get time since reference date for right now
            let formatter2 = DateFormatter()
            formatter2.dateFormat = "yyyy-MM-dd"
            let currentInterval = formatter2.date(from: dateString)!.timeIntervalSinceReferenceDate
            
            // If there is an old date, get its time since reference date
            var oldInterval: TimeInterval = TimeInterval(0)
            if self.settings.mostRecentDate != nil {
                oldInterval = formatter2.date(from: self.settings.mostRecentDate!)!.timeIntervalSinceReferenceDate
            }
            
            // If no first date, need to make list and put value in (set firstDate, mostRecentDate, and dailyTimes)
            if self.settings.firstDate == nil {
                // Save current date as firstDate and mostRecentDate
                UserDefaults.standard.set(dateString, forKey: "firstDate")
                self.settings.firstDate = dateString
                UserDefaults.standard.set(dateString, forKey: "mostRecentDate")
                self.settings.mostRecentDate = dateString
                
                // Add new record for today and save
                var newArray: [Double] = []
                newArray.append(self.timePassed)
                self.settings.dailyTimes = newArray
                UserDefaults.standard.set(newArray, forKey: "dailyTimes")
        
            // If there is a first date
            } else {
                // If there is no record for today, add it (update mostRecentDate and dailyTimes)
                if currentInterval != oldInterval {
                    // Save date as the most recently
                    UserDefaults.standard.set(dateString, forKey: "mostRecentDate")
                    self.settings.mostRecentDate = dateString
                    
                    // Get existing list of values
                    var oldArray: [Double] = self.settings.dailyTimes as! [Double]
                    // Calculate amount of days passed and add a 0 for each
                    let numDaysBetween = ((Float(currentInterval) - Float(oldInterval)) / 86400.0) - 1
                    if Int(numDaysBetween) >= 1 {
                        for _ in 1...Int(numDaysBetween) {
                            oldArray.append(0)
                        }
                    }
                    // Add new time
                    oldArray.append(self.timePassed)
                    self.settings.dailyTimes = oldArray
                    UserDefaults.standard.set(oldArray, forKey: "dailyTimes")
                    
                // If there is already a record for today, increase it (update dailyTimes)
                } else {
                    // Add new time for today and save
                    var oldArray: [Double] = self.settings.dailyTimes as! [Double]
                    var lastValue: Double = oldArray.popLast()!
                    lastValue += self.timePassed
                    oldArray.append(lastValue)
                    self.settings.dailyTimes = oldArray
                    UserDefaults.standard.set(oldArray, forKey: "dailyTimes")
                }
            }
        }
    }
    
    // If correct note, then 10 points; if one half step away, then 5 points; if one whole step away, then 3 points; increase streak count for target, neutral for half step off, reset for whole note or worse
    func updateScore(value: Note) {
        totalNotesPlayed += 1
        switch measures[currBar].notes[beatIndex].step + measures[currBar].notes[beatIndex].accidental {
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
        timePassed += tuner.pollingInterval
        
        // Convert beatCount to seconds by multiplying by sampling rate, then to minutes by dividing by 60. Then multiply by tempo (bpm) to get tempo count
        let newElapsedBeats: Float = (Float(beatCount) * Float(tuner.pollingInterval) / Float(60) * Float(tempo))
        var updateEndOfNextNote = false
        
        // If still on current note, add pitch reading to array
        if newElapsedBeats < endOfCurrentNoteBeats {
            currBeatNotes.append(pitch.note)
        }
        // If new beat, calculate score and empty list for next beat
        else if self.isOn {
            // Frequency calculation algorithm from: https://stackoverflow.com/questions/38416347/getting-the-most-frequent-value-of-an-array
            
            // Create dictionary to map value to count and get most frequent note
            var counts = [Note: Int]()
            currBeatNotes.forEach { counts[$0] = (counts[$0] ?? 0) + 1 }
            let (value, _) = counts.max(by: {$0.1 < $1.1}) ?? (Note(Note.Name(rawValue: 0)!,Note.Accidental(rawValue: 0)!), 0)
            
            if !self.measures[self.currBar].notes[self.beatIndex].isRest {
                updateScore(value: value)
            }
            
            // Empty current beat note values array for next beat
            currBeatNotes = []
            
            // Go to next beat
            beatIndex += 1
            
            // Nee to update end of next note
            updateEndOfNextNote = true
            
        }
        
        // Keep track of current bar
        if Int(newElapsedBeats) > Int(self.totalElapsedBeats) {
            // If switching to new bar
            if self.measureBeat == measures[currBar].timeSig.0 - 1 &&
                Int(newElapsedBeats) != 0 {
                // End song
                if self.currBar == self.measures.count - 1 {
                    self.tuner.stop()
                    self.isOn = false
                    self.isOver = true
                    beatIndex -= 1
                } else {
                    beatIndex = 0
                    self.currBar += 1
                    self.measureBeat = 0
                    self.rewound = false
                }
            }
            else {
                self.measureBeat += 1
            }
        }

        if updateEndOfNextNote && self.isOn {
            endOfCurrentNoteBeats = endOfCurrentNoteBeats + measures[currBar].notes[beatIndex].duration
            updateEndOfNextNote = false
        }

        if self.isOn {
            // Update tempo count
            self.totalElapsedBeats = newElapsedBeats
            
            // If exceeded tuner threshold for new note, update the new note
            if change {
                self.note = pitch.note
                self.cents = calulateCents(userFrequency: frequency, noteFrequency: pitch.frequency)
            }
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
        let keySigOffset = Float(Double(measures[currBar].fifths) * 20.0)
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
    
    // Calculates length and angle of connecting bar
    func calcFlagAngle(startNote: NoteMetadata, endNote: NoteMetadata, currNote: NoteMetadata, length: Double, ratio: Double) -> (Double, Double, Double, Bool) {
        let startOffset = self.calcNoteOffset(note: startNote.step, octave: startNote.octave)
        let endOffset = self.calcNoteOffset(note: endNote.step, octave: endNote.octave)
        let vertDist: Int = endOffset - startOffset
        let currOffset = self.calcNoteOffset(note: currNote.step, octave: currNote.octave)

        let startFacingUp = startOffset > Int(self.barDist + 10) * 2
        
        var tailLengthChange: Double = 0
        var otherSide: Bool = false
        // If above the bar, 60 is length of tail stem
        if ((currOffset - startOffset) < -60) && startFacingUp {
            otherSide = true
            let topOfBeam: Double = Double(startOffset) - 60.0 + Double(vertDist) * (ratio - 34.0 / length)
            let bottomOfFlag: Double = Double(currOffset) - 60.0
            tailLengthChange = bottomOfFlag - topOfBeam - Double(self.barDist / 2)
        // If below the bar
        } else if ((currOffset - startOffset) > 60) && !startFacingUp {
            otherSide = true
            let bottomOfBeam: Double = Double(startOffset) + 60.0 + Double(vertDist) * (ratio - 34.0 / length)
            let topOfFlag: Double = Double(currOffset) + 60.0
            tailLengthChange = bottomOfBeam - topOfFlag // + Double(self.barDist / 2)
        } else {
            let changeForSlope = Double(vertDist) * -ratio
            let changeForOffset = Double(startOffset - currOffset)
            let currFacingUp = currOffset > Int(self.barDist + 10) * 2
            tailLengthChange = currFacingUp ? (changeForSlope - changeForOffset) : (changeForOffset - changeForSlope)
        }
        
        let hypotenuse: Double = Double(Double(vertDist * vertDist) + Double(length * length)).squareRoot()
        var angle: Double = 0
        if hypotenuse > 0 {
            angle = asin(Double(vertDist) / hypotenuse)
        }
                
        return (hypotenuse, angle, tailLengthChange, otherSide)
    }
    
    func drawNote(note: NoteMetadata, barIndex: Int, barNumber: Int, addOffset: Int) -> some View {
        let offset = self.calcNoteOffset(note: note.step, octave: note.octave)
         
        // Get offset between each pair of notes
        let index = self.measures[barIndex].notes.firstIndex(of: note)
        var beatOffset: Float = 0
        if index! > 0 {
            for i in 1...index!{
                beatOffset += self.measures[barIndex].notes[i - 1].duration
            }
        }
        
        // If previous is the same, this note will have the beam starting at it
        var isPrevSame: Bool = false
        if index! > 0 {
            if (self.measures[barIndex].notes[index! - 1].type == note.type) && (!self.measures[barIndex].notes[index! - 1].isRest) {
                isPrevSame = true
            }
        }
        
        var followingSameCount: Int = 0 // Used to calculate how long the beam should be
        var prevSameCount: Int = 0 // Used to calculate how long the beam should be
        var breakReached: Bool = false // Used for calculting how many notes should be connected with the beam
        var startNote: NoteMetadata = note // First note in beam set
        var endNote: NoteMetadata = note // Last note in beam set
        
        // If eighth note, check whether there is a following eighth note
        if (note.type == "eighth")  {
            if index! < self.measures[barIndex].notes.count - 1 {
                if self.measures[barIndex].notes[index! + 1].type == note.type {
                    if !self.measures[barIndex].notes[index! + 1].isRest {
                        followingSameCount += 1
                        endNote = self.measures[barIndex].notes[index! + 1]
                    }
                }
            }
        // If 16th note, need to explore previous and following notes to see if matching
        } else if (note.type == "16th") {
            if index! < self.measures[barIndex].notes.count - 1 {
                for i in index! + 1 ... self.measures[barIndex].notes.count - 1 {
                    if !breakReached {
                        if self.measures[barIndex].notes[i].type == note.type {
                            if !self.measures[barIndex].notes[i].isRest {
                                followingSameCount += 1
                                endNote = self.measures[barIndex].notes[i]
                                if followingSameCount == 3 {
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
                breakReached = false
            }
            if index! > 0 {
                let revPrevNotes = Array<NoteMetadata>(self.measures[barIndex].notes[0 ... index! - 1].reversed())
                for i in 0 ... revPrevNotes.count - 1 {
                    if !breakReached {
                        if revPrevNotes[i].type == note.type {
                            if !revPrevNotes[i].isRest {
                                prevSameCount += 1
                                startNote = revPrevNotes[i]
                                if prevSameCount == 3 {
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
        let barBeatDiv: Float = scrollLength / Float(4)
        let beat = self.measureBeat + 1 + addOffset
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
        let fifths = self.measures[self.currBar].fifths
        if fifths > 0 {
            keySigAccidentals = Array<String>(sharpOrder[0 ... fifths - 1])
        } else if fifths < 0 {
            keySigAccidentals = Array<String>(flatOrder[0 ... -fifths - 1])
        }
        
        // Calculate the flag length and angle as well as the tail length offset for the current note (also whether it lies on the "wrong" side of the beam)
        var flagLength: Double = 0
        var flagAngle: Double = 0
        var additionalOffset: Double = 0
        var otherSide: Bool = false
        
        if note.type == "eighth" {
            (flagLength, flagAngle, additionalOffset, otherSide) = self.calcFlagAngle(startNote: startNote, endNote: endNote, currNote: note, length: Double(barBeatDiv / 2), ratio: (Double(prevSameCount) / Double(followingSameCount + prevSameCount)))
        } else if note.type == "16th" {
            (flagLength, flagAngle, additionalOffset, otherSide) = self.calcFlagAngle(startNote: startNote, endNote: endNote, currNote: note, length: Double(barBeatDiv / 4) * Double(followingSameCount + prevSameCount), ratio: (Double(prevSameCount) / Double(followingSameCount + prevSameCount)))
        }
        
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
                        .modifier(TailStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity, facingUp: facingUp, additionalHeight: additionalOffset, otherSide: otherSide))
                    if (followingSameCount >= 1) && (!isPrevSame){
                        Rectangle()
                            .modifier(FlagStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity, facingUp: facingUp, position: 0, givenWidth: flagLength, angle: flagAngle))
                        Rectangle()
                            .modifier(FlagStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity, facingUp: facingUp, position: 1, givenWidth: flagLength, angle: flagAngle))
                    } else if !isPrevSame {
                        Rectangle()
                            .modifier(FlagStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity, facingUp: facingUp, position: 0, givenWidth: -1, angle: flagAngle))
                        Rectangle()
                            .modifier(FlagStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity, facingUp: facingUp, position: 1, givenWidth: -1, angle: flagAngle))
                    }
                }
                else if note.type == "eighth" {
                    Circle()
                        .frame(width: 34.0, height: 34.0)
                        .modifier(NoteStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity))
                    Rectangle()
                        .modifier(TailStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity, facingUp: facingUp, additionalHeight: 0, otherSide: otherSide))
                    
                    if (followingSameCount >= 1) && (!isPrevSame) {
                        Rectangle()
                            .modifier(FlagStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity, facingUp: facingUp, position: 0, givenWidth: flagLength, angle: flagAngle))
                    } else if !isPrevSame {
                        Rectangle()
                            .modifier(FlagStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity, facingUp: facingUp, position: 0, givenWidth: -1, angle: flagAngle))
                    }
                }
                else if note.type == "quarter" {
                    Circle()
                        .frame(width: 34.0, height: 34.0)
                        .modifier(NoteStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity))
                    Rectangle()
                        .modifier(TailStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity, facingUp: facingUp, additionalHeight: 0, otherSide: otherSide))
                }
                else if note.type == "half" {
                    Circle()
                        .stroke(Color.black, lineWidth: 4)
                        .modifier(NoteStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity))
                    Rectangle()
                        .modifier(TailStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity, facingUp: facingUp, additionalHeight: 0, otherSide: otherSide))
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
                        .modifier(TailStyle(offset: offset, scrollOffset: scrollOffset, opacity: opacity, facingUp: facingUp, additionalHeight: 0, otherSide: otherSide))
                }
            }
            
            if note.dot {
                Circle()
                    .modifier(NoteDotStyle(offset: offset, scrollOffset: 40 + scrollOffset, opacity: opacity))
            }
        }
    }
    
    func drawMeasure(msr: Int) -> some View {
        return Group {
            if msr < self.measures.count {
                ForEach(self.measures[msr].notes) { note in
                    self.drawNote(note: note, barIndex: msr, barNumber: 0, addOffset: 0)
                }
            }
            
            if msr + 1 < self.measures.count {
                self.drawMeasureBar(barIndex: msr + 1, barNumber: 0, end: false, addOffset: 4 - self.measures[msr].timeSig.0)
                ForEach(self.measures[msr + 1].notes) { note in
                    self.drawNote(note: note, barIndex: msr + 1, barNumber: 1, addOffset: 4 - self.measures[msr].timeSig.0)
                }
            } else if msr < self.measures.count{
                self.drawMeasureBar(barIndex: 0, barNumber: 0, end: true, addOffset: 4 - self.measures[msr].timeSig.0)
            } else {
                self.drawMeasureBar(barIndex: 0, barNumber: 0, end: true, addOffset: 0)
            }
            
            
            if msr + 2 < self.measures.count {
                self.drawMeasureBar(barIndex: msr + 2, barNumber: 1, end: false, addOffset: 4 - self.measures[msr].timeSig.0 - self.measures[msr + 1].timeSig.0 + 4)
                ForEach(self.measures[msr + 2].notes) { note in
                    self.drawNote(note: note, barIndex: msr + 2, barNumber: 2, addOffset: 4 - self.measures[msr].timeSig.0 - self.measures[msr + 1].timeSig.0 + 4)
                }
            } else if msr + 1 < self.measures.count {
                self.drawMeasureBar(barIndex: 0, barNumber: 1, end: true, addOffset: 4 - self.measures[msr].timeSig.0 - self.measures[msr + 1].timeSig.0 + 4)
            } else if msr < self.measures.count {
                self.drawMeasureBar(barIndex: 0, barNumber: 1, end: true, addOffset: 4 - self.measures[msr].timeSig.0)
            } else {
                self.drawMeasureBar(barIndex: 0, barNumber: 1, end: true, addOffset: 0)
            }
        }
    }
    
    func drawMeasureBar(barIndex: Int, barNumber: Int, end: Bool, addOffset: Int) -> some View {
        let barBeatDiv: Float = scrollLength / Float(4)
        let beat = self.measureBeat + 1 + addOffset
        let beatDiff = self.totalElapsedBeats - Float(Int(self.totalElapsedBeats))
        let scrollOffset = scrollLength + (barBeatDiv * 0.875) - Float(barBeatDiv * (Float(beat) + beatDiff)) + (Float(barNumber) * scrollLength)
        
        let opacity = calcOpacity(scrollOffset: scrollOffset)
        
        return Group {
            Rectangle()
                .fill(Color.black)
                .frame(width: 5, height: 126)
                .offset(x: CGFloat(scrollOffset), y: CGFloat(-11))
                .opacity(opacity)
            if end {
                Rectangle()
                .fill(Color.black)
                .frame(width: 9, height: 126)
                .offset(x: CGFloat(scrollOffset) + 11, y: CGFloat(-11))
                .opacity(opacity)
            }
        }
    }
    
    func drawPlayLine() -> some View {
        let currNote = self.measures[currBar].notes[beatIndex]
        let offset = self.calcNoteOffset(note: currNote.step, octave: currNote.octave)
        let fullLength: Float = (scrollLength / Float(4)) * currNote.duration
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
        switch measures[currBar].notes[beatIndex].step + measures[currBar].notes[beatIndex].accidental {
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
        PlayMode(rootIsActive: .constant(false), songMetadata: SongMetadata(songId: -1, name: "", artist: "", resourceUrl: "", year: -1, level: -1, topScore: -1, highScore: -1, highScoreId: -1, deleted: false, rank: ""), tempo: 120, isSong: true, tuner: Tuner(), xmlString: "").previewLayout(.fixed(width: 896, height: 414))
    }
}
