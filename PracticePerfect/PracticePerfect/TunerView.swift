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
    @State var tuner = Tuner()
    @State var frequency = 0.0
    @State var note = Note(Note.Name.c, Note.Accidental.natural)
    @State var octave = 0
    @State var currErrRatio = 0.0
    @State var tunerOn = false
    
    func tunerDidTick(pitch: Pitch, errRatio: Double) {
        self.currErrRatio = errRatio > 1 ? 2 - errRatio : errRatio
        self.frequency = pitch.frequency
        self.note = pitch.note
        self.octave = pitch.octave
    }
    
    var body: some View {
        VStack {
            if !tunerOn {
                Button(action: {
                    self.tuner.delegate = self
                    self.tuner.start()
                    self.tunerOn = true
                }) {
                    Text("Start Tuner")
                }
            } else {
                Text(displayNote())
                Text(String(currErrRatio))
                Button(action: {
                    self.tuner.stop()
                    self.tunerOn = false
                }) {
                    Text("Stop Tuner")
                }
            }
        }
        .background(Color.green.opacity(currErrRatio))
        .navigationBarTitle("Tuner")
    }

    
    func displayNote() -> String {
        var noteName: String
        var accidental: String
        
        switch note.note {
            case .a:
                noteName = "A"
            case .b:
                noteName = "B"
            case .c:
                noteName = "C"
            case .d:
                noteName = "D"
            case .e:
                noteName = "E"
            case .f:
                noteName = "F"
            case .g:
                noteName = "G"
        }
        
        switch note.accidental {
            case .sharp:
                accidental = "\u{266F}"
            case .flat:
                accidental = "\u{266D}"
            case .natural:
                accidental = ""
        }

        return noteName + accidental
    }
}

struct TunerView_Previews: PreviewProvider {
    static var previews: some View {
        TunerView().previewLayout(.fixed(width: 896, height: 414))
    }
}
