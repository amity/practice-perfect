//
//  ResultsPage.swift
//  PracticePerfect
//
//  Created by Sean Hawkins on 11/12/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//

import SwiftUI

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
                    Spacer()
                    HStack {
                        VStack {
                            Text("New Score")
                                .font(Font.title.weight(.bold))
                            Text("\(scoreMetadata.newScore)")
                                .font(.largeTitle)
                        }

                        Spacer()

                        VStack {
                            Text("Grade")
                                .font(Font.title.weight(.bold))
                            // Calculate new rank from the new score and top possible score
                            Text("\(calculateRank(newScore: scoreMetadata.newScore, topScore: songMetadata.topScore))")
                                .font(.largeTitle)
                        }
                    }

                    Spacer()

                    if (scoreMetadata.totalCount > 0) {
                        Text("You played \(Int(100 * Float(scoreMetadata.perfectCount) / Float(scoreMetadata.totalCount)) + Int(100 * Float(scoreMetadata.goodCount) / Float(scoreMetadata.totalCount)))% of your notes in tune or almost in tune this time!")
                            .font(.title)
                            .multilineTextAlignment(.center)
                    } else {
                        Text("You played 0% of your notes in tune or almost in tune this time!")
                            .font(.title)
                            .multilineTextAlignment(.center)
                    }

                    Spacer()

                    HStack {
                        VStack {
                            Text("Previous Score")
                                .font(Font.title.weight(.bold))
                            Text("\(songMetadata.highScore)")
                                .font(.largeTitle)
                        }

                        Spacer()

                        VStack {
                            Text("Grade")
                                .font(Font.title.weight(.bold))
                            // Calculate new rank from the new score and top possible score
                            Text("\(calculateRank(newScore: songMetadata.highScore, topScore: songMetadata.topScore))")
                                .font(.largeTitle)
                        }
                    }
                    Spacer()
                }
                Spacer()
                VStack {
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
            }
        }
        .foregroundColor(.black)
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
    }
}

struct ResultsPage_Previews: PreviewProvider {
    static var previews: some View {
        // Preview with example song metadata
        ResultsPage(scoreMetadata: ScoreMetadata(
                newScore: 9000,
                inTuneCount: 9560,
                inTempoCount: 9756,
                perfectCount: 9400,
                goodCount: 450,
                missCount: 250,
                totalCount: 1000000
            ),
            songMetadata: SongMetadata(
                songId: -1, 
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

