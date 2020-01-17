//
//  ResultsPage.swift
//  PracticePerfect
//
//  Created by Sean Hawkins on 11/12/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//

import SwiftUI

// Formats integer in scoreMetadata into percent
func formatPercent(percentInt: Int) -> String {
    let convertedString = String(percentInt)
    // If five digits
    if percentInt == 10000 {
        return convertedString.prefix(3) + "." + convertedString.suffix(2) + "%"
    }
    // If four digits
    else if percentInt >= 1000 {
        return convertedString.prefix(2) + "." + convertedString.suffix(2) + "%"
    }
    // If three digits
    else {
        return convertedString.prefix(1) + "." + convertedString.suffix(2) + "%"
    }
}

func calculateRank(newScore: Int, topScore: Int) -> String {
    if Float(newScore) >= Float(topScore) * 0.8 {
        return "A"
    } else if Float(newScore) >= Float(topScore) * 0.65 {
        return "B"
    } else if Float(newScore) >= Float(topScore) * 0.55 {
        return "C"
    } else if Float(newScore) >= Float(topScore) * 0.50 {
        return "D"
    } else if Float(newScore) >= 0 {
        return "F"
    } else {
        return "No rank"
    }
}

struct ResultsPage: View {
    @State var scoreMetadata: ScoreMetadata
    @State var songMetadata: SongMetadata
    
    var body: some View {
        ZStack {
            mainGradient

            HStack {
                Spacer()
                VStack {
                    // Calculate new rank from the new score and top possible score
                    Text("\(calculateRank(newScore: scoreMetadata.newScore, topScore: songMetadata.topScore))")
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
                    Text("New Score")
                    Text("\(scoreMetadata.newScore)")
                        .font(.system(size: 48))
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Perfect: \(formatPercent(percentInt: scoreMetadata.perfectPercent))")
                            Text("Good: \(formatPercent(percentInt: scoreMetadata.goodPercent))")
                            Text("Missed: \(formatPercent(percentInt: scoreMetadata.missPercent))")
                        }
                        .padding(.trailing, 20)
                        VStack(alignment: .leading) {
                            Text("Pitch: \(formatPercent(percentInt: scoreMetadata.pitchPercent))")
                                .frame(alignment: .leading)
                            Text("Tempo: \(formatPercent(percentInt: scoreMetadata.tempoPercent))")
                                .frame(alignment: .leading)
                        }
                        .padding(.leading, 20)
                    }
                        .font(.system(size: 24))
                        .padding(.vertical, 20)
                    Text("Previous High Score")
                    Text("\(songMetadata.highScore)")
                        .font(.system(size: 48))
                }
                    .font(Font.system(size: 24).weight(.medium))

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
                newScore: 9000,
                pitchPercent: 9560,
                tempoPercent: 9756,
                perfectPercent: 9400,
                goodPercent: 450,
                missPercent: 250
            ),
            songMetadata: SongMetadata(
                id: -1,
                name: "",
                artist: "",
                resourceUrl: "",
                year: -1,
                level: -1,
                topScore: -1,
                highScore: -1,
                highScoreId: -1, 
                deleted: false,
                rank: ""
            )
        ).previewLayout(.fixed(width: 896, height: 414))
    }
}

