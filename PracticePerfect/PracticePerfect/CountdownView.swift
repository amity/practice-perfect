//
//  CountdownView.swift
//  PracticePerfect
//
//  Created by Anna Matusewicz on 11/14/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//

import SwiftUI

struct Countdown: View {
    @Environment(\.presentationMode) var presentationMode
    var tempo: Int // Beats per minute
    var beats: Int // Number to count to
    @Binding var showCountdown: Bool
    @State var count = 1
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    
    var body: some View {
        Text("\(count)")
            .onReceive(timer) {_ in
                if self.count < self.beats - 1 {
                    self.count += 1
                } else {
                    self.showCountdown = false
                }
            }
            .font(Font.custom("Arial Rounded MT Bold", size: 100))
        .background(
            Circle()
                .fill(Color.white)
                .shadow(color: .blue, radius: 10)
                .frame(width: 200, height: 200)
        )
    }
}
