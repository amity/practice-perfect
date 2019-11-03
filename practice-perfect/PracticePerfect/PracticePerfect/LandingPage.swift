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
            
            Button(action: {}) {
                Text("Play!").foregroundColor(Color.black)
            }
            
            Button(action: {}) {
                Text("Settings").foregroundColor(Color.black)
            }
            
        }
    }
}

struct LandingPage_Previews: PreviewProvider {
    static var previews: some View { LandingPage().previewLayout(.fixed(width: 896, height: 414))
    }
}
