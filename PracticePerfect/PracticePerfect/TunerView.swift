//
//  TunerView.swift
//  PracticePerfect
//
//  Created by Anna Matusewicz on 11/3/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//

import SwiftUI
import AudioKit

struct TunerView: View, TunerDelegate {
    @EnvironmentObject var settings: UserSettings
    
    @State var userFrequency = 261.6255653005986
    @State var noteFrequency = 261.6255653005986
    @State var note = Note(Note.Name.c, Note.Accidental.natural)
    @State var tunerOn = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [makeSideColor(), makeMiddleColor(), makeSideColor()]), startPoint: .leading, endPoint: .trailing)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                Text(displayNote(note: note))
                    .modifier(NoteNameStyle())
                HStack {
                    Text("Flat")
                        .modifier(AccidentalStyle())
                        .opacity(max(0, calulateCents(userFrequency: userFrequency, noteFrequency: noteFrequency) / -50))
                    Spacer()
                    Text("Sharp")
                        .modifier(AccidentalStyle())
                        .opacity(max(0, calulateCents(userFrequency: userFrequency, noteFrequency: noteFrequency) / 50))
                }
                Spacer()
                if !tunerOn {
                    Button(action: {
                        self.startTuner()
                    }) {
                        Text("Resume Tuner")
                    }
                        .modifier(ButtonStyle())
                } else {
                    Button(action: {
                        self.settings.tuner.stop()
                        self.tunerOn = false
                    }) {
                        Text("Pause Tuner")
                    }
                        .modifier(ButtonStyle())
                }
            }
            .onAppear(perform: startTuner)
            .navigationBarTitle("Tuner")
            .onDisappear(perform: self.settings.tuner.stop)
        }
    }
    
    // Updates current note information from microphone
    func tunerDidTick(pitch: Pitch, frequency: Double, beatCount: Int, change: Bool) {
        self.userFrequency = frequency
        self.noteFrequency = pitch.frequency
        self.note = pitch.note
    }
    
    func startTuner() {
        self.settings.tuner.delegate = self
        self.settings.tuner.start()
        self.tunerOn = true
    }

    func makeSideColor() -> Color {
        let colors = setGreenRed()
        let red = colors.0
        let green = colors.1
        return Color(red: (red - 70)/255.0, green: (green - 70)/255.0, blue: 0.0/255.0)
    }
    
    func makeMiddleColor() -> Color {
        let colors = setGreenRed()
        let red = colors.0
        let green = colors.1
        return Color(red: red/255.0, green: green/255.0, blue: 0.0/255.0)
    }
    
    func setGreenRed() -> (Double, Double) {
        let red: Double
        let green: Double
        let cents = abs(calulateCents(userFrequency: userFrequency, noteFrequency: noteFrequency))
        if cents < 25 {
            green = 255.0
            red = 255.0 * (cents / 25.0)
        } else {
            red = 255.0
            green = 255.0 * ((50 - cents) / 25.0)
        }
        
        return (red, green)
    }
}

struct TunerView_Previews: PreviewProvider {
    static var previews: some View {
        TunerView().previewLayout(.fixed(width: 896, height: 414))
    }
}
