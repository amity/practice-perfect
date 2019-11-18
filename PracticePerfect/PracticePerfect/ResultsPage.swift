//
//  ResultsPage.swift
//  PracticePerfect
//
//  Created by Sean Hawkins on 11/12/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//

import SwiftUI

// Formats integer in scoreMetadata into percent
func formatPercent(scoreInt: Int) -> String {
    let convertedString = String(scoreInt)
    // If five digits
    if scoreInt == 10000 {
        return convertedString.prefix(3) + "." + convertedString.suffix(2) + "%"
    }
    // If four digits
    else if scoreInt >= 1000 {
        return convertedString.prefix(2) + "." + convertedString.suffix(2) + "%"
    }
    // If three digits
    else {
        return convertedString.prefix(1) + "." + convertedString.suffix(2) + "%"
    }
}

struct ResultsPage: View {
    @State var scoreMetadata: ScoreMetadata
    @State var prevHighScore: Int
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text("\(scoreMetadata.overallRank)")
                    .font(.system(size: 60))
                ZStack {
                    Color.gray
                        .frame(width: 300, height: 75)
                    NavigationLink(destination: SelectMusic()) {
                        Text("Choose another song")
                            .font(.system(size: 28))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                ZStack {
                    Color.gray
                        .frame(width: 300, height: 75)
                    NavigationLink(destination: LandingPage()) {
                        Text("Menu")
                            .font(.system(size: 28))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            Spacer()
            VStack {
                Text("\(formatPercent(scoreInt: scoreMetadata.scorePercent))")
                    .font(.system(size: 48))
                HStack {
                    VStack(alignment: .leading) {
                        Text("Perfect: \(scoreMetadata.perfectCount)")
                            .font(.system(size: 24))
                        Text("Good: \(scoreMetadata.goodCount)")
                            .font(.system(size: 24))
                        Text("Missed: \(scoreMetadata.missCount)")
                            .font(.system(size: 24))
                    }
                    .padding(.trailing, 20)
                    VStack(alignment: .leading) {
                        Text("Pitch: \(scoreMetadata.pitchRank)")
                            .font(.system(size: 24))
                            .frame(alignment: .leading)
                        Text("Tempo: \(scoreMetadata.tempoRank)")
                            .font(.system(size: 24))
                            .frame(alignment: .leading)
                    }
                    .padding(.leading, 20)
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
                Text("New Score: \(scoreMetadata.newScore)")
                    .font(.system(size: 32))
                    .fontWeight(.medium)
                Text("High Score: \(prevHighScore)")
                    .font(.system(size: 32))
                    .fontWeight(.medium)
            }
            Spacer()
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
    }
}

struct ResultsPage_Previews: PreviewProvider {
    static var previews: some View {
        // Preview with example song metadata
        ResultsPage(scoreMetadata: ScoreMetadata(
                overallRank: "A",
                pitchRank: "A",
                tempoRank: "A",
                newScore: 9000,
                scorePercent: 9756,
                perfectCount: 100,
                goodCount: 10,
                missCount: 1
            ),
            prevHighScore: 100
        ).previewLayout(.fixed(width: 896, height: 414))
    }
}

