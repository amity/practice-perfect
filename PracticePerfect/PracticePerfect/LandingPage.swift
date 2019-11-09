//
//  LandingPage.swift
//  Practice Perfect
//
//  Created by Abigail Chen on 11/3/19.
//  Copyright © 2019 CS98 Practice Perfect. All rights reserved.
//

import SwiftUI

struct LandingPage: View {
    
    var body: some View {
        VStack {
            Text("Practice Perfect")
                .fontWeight(.semibold)
            
            NavigationLink(destination: SelectMusic()) {
                Text("Play").foregroundColor(Color.black)
            }
            
            NavigationLink(destination: PracticeView()) {
                Text("Practice").foregroundColor(Color.black)
            }
            
            NavigationLink(destination: TunerView()) {
                Text("Tuner").foregroundColor(Color.black)
            }
            
            NavigationLink(destination: SettingsView()) {
                Text("Settings").foregroundColor(Color.black)
            }
            
        }
    }
}

struct LandingPage_Previews: PreviewProvider {
    static var previews: some View { LandingPage().previewLayout(.fixed(width: 896, height: 414))
    }
}
