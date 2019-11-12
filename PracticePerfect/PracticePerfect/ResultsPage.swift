//
//  ResultsPage.swift
//  PracticePerfect
//
//  Created by Sean Hawkins on 11/12/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//

import SwiftUI

struct ResultsPage: View {
    @State var scoreMetadata: ScoreMetadata
    @Binding var isNavigationBarHidden: Bool
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Text("RANK")
                    .font(.system(size: 44))
                Spacer()
                NavigationLink(destination: SelectMusic()) {
                    Text("Choose another song")
                }
                NavigationLink(destination: LandingPage()) {
                    Text("Menu")
                }
                Spacer()
            }
            Spacer()
            VStack {
                Spacer()
                Text("RANK")
                    .font(.system(size: 44))
                Spacer()
                HStack {
                    Text("Scores")
                        .font(.system(size: 24))
                    Text("Ranks")
                        .font(.system(size: 24))
                }
                Spacer()
                Text("Score")
                    .font(.system(size: 24))
                Text("High Score")
                    .font(.system(size: 24))
                Spacer()
            }
            Spacer()
        }
        .navigationBarTitle("")
        .navigationBarHidden(self.isNavigationBarHidden)
        .onAppear {
            self.isNavigationBarHidden = true
        }
//        .navigationBarBackButtonHidden(true)
//        .navigationBarHidden(true)
    }
}

//struct ResultsPage_Previews: PreviewProvider {
//    static var previews: some View {
//        // Preview with example song metadata
//        ResultsPage().previewLayout(.fixed(width: 896, height: 414))
//    }
//}

