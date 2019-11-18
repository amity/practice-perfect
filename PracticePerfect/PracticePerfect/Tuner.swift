//
//  Tuner.swift
//  PracticePerfect
//
//  Created by Anna Matusewicz on 11/5/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//

import AudioKit
import Foundation


// Amplitude threshhold for filtering background noise
// In the future, we could judge off of an audio sample of the environment
let threshold = 0.05

// Shared function used by PlayMode and TunerView
func displayNote(note: Note) -> String {
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

// Calculates the cents off of in tune
// Equation taken from:
// http://www.sengpielaudio.com/calculator-centsratio.htm
func calulateCents(userFrequency: Double, noteFrequency: Double) -> Double {
    let cents = 1200 * log2(userFrequency / noteFrequency)
    if cents > 50 || cents < -50 || (cents < 5 && cents > -5) {
        return 0
    }
    return cents
}

// Written following a tutorial found at:
// http://shinerightstudio.com/posts/ios-tuner-app-using-audiokit/
class Tuner {
    let mic: AKMicrophone
    let tracker: AKFrequencyTracker
    let silence: AKBooster
    let pollingInterval = 0.05
    var pollingTimer: Timer?
    var delegate: TunerDelegate?

    init() {
        do {
            // Configure settings of AVFoundation.
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement)
        } catch let error {
            print(error.localizedDescription)
        }

        AKSettings.audioInputEnabled = true
        mic = AKMicrophone()!
        tracker = AKFrequencyTracker.init(mic)
        silence = AKBooster(tracker, gain: 0)

        AudioKit.output = silence
    }

    func start() {
        do {
            try AudioKit.start()
        } catch let error {
            print(error.localizedDescription)
        }

        pollingTimer = Timer.scheduledTimer(withTimeInterval: pollingInterval, repeats: true, block: {_ in self.pollingTick()})
    }

    func stop() {
        do {
            try AudioKit.stop()
        } catch let error {
            print(error.localizedDescription)
        }

        if let t = pollingTimer {
            t.invalidate()
        }
        
    }

    private func pollingTick() {
        let frequency = Double(tracker.frequency)
        let pitch = Pitch.makePitchByFrequency(frequency)
        
        if tracker.amplitude > threshold, let d = delegate {
            d.tunerDidTick(pitch: pitch, frequency: frequency)
        }
    }
}

protocol TunerDelegate {
    func tunerDidTick(pitch: Pitch, frequency: Double)
}
