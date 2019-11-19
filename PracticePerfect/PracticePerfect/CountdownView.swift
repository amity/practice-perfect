//
//  CountdownView.swift
//  PracticePerfect
//
//  Created by Anna Matusewicz on 11/14/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//

import SwiftUI
import Combine

struct Countdown: View {
    @Binding var showCountdown: Bool
    private var tempo: Int // Beats per minute
    private var beats: Int // Number to count to
    private var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    private var callback: (() -> Void)? = nil

    @State var count = 1

    init (tempo: Int, beats: Int, showCountdown: Binding<Bool>, callback: (() -> Void)? = nil) {
        self.tempo = tempo
        self.beats = beats
        self._showCountdown = showCountdown
        self.callback = callback

        let interval = 60.0 / Double(tempo)
        self.timer = Timer.publish(every: interval, on: .current, in: .common).autoconnect()
    }
    
    var body: some View {
        Text("\(count)")
            .onReceive(timer) {_ in
                if self.count < self.beats {
                    self.count += 1
                } else {
                    self.showCountdown = false
                    if (self.callback != nil) {
                        self.callback!()
                    }
                }
            }
            .font(Font.custom("Arial Rounded MT Bold", size: 100))
            .background(
                Circle()
                    .fill(Color.white)
                    .shadow(color: .gray, radius: 10)
                    .frame(width: 200, height: 200)
            )
    }
}

struct Countdown_Previews: PreviewProvider {
    static var previews: some View {
        // Example with sample SongMetadata
        Countdown(tempo: 120, beats: 4, showCountdown: .constant(true)).previewLayout(.fixed(width: 896, height: 414))
    }
}
