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
        ZStack {
            mainGradient

            HStack {
                Spacer()
                VStack {
                    Text("\(scoreMetadata.overallRank)")
                        .font(.system(size: 60))
                    NavigationLink(destination: SelectMusic()) {
                        Text("Choose another song")
                            .frame(width: 200)
                    }
                    .modifier(MenuButtonStyle())
                    .padding()

                    NavigationLink(destination: LandingPage()) {
                        Text("Menu")
                            .frame(width: 200)
                    }
                    .modifier(MenuButtonStyle())
                }
                Spacer()
                VStack {
                    Text("\(formatPercent(scoreInt: scoreMetadata.scorePercent))")
                        .font(.system(size: 48))
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Perfect: \(scoreMetadata.perfectCount)")
                            Text("Good: \(scoreMetadata.goodCount)")
                            Text("Missed: \(scoreMetadata.missCount)")
                        }
                        .padding(.trailing, 20)
                        VStack(alignment: .leading) {
                            Text("Pitch: \(scoreMetadata.pitchRank)")
                                .frame(alignment: .leading)
                            Text("Tempo: \(scoreMetadata.tempoRank)")
                                .frame(alignment: .leading)
                        }
                        .padding(.leading, 20)
                    }
                        .font(.system(size: 24))
                        .padding(.vertical, 20)

                    Text("New Score: \(scoreMetadata.newScore)")
                    Text("High Score: \(prevHighScore)")
                }
                    .font(Font.system(size: 32).weight(.medium))

                Spacer()
            }
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

