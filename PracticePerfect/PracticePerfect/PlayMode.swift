//
//  PlayMode.swift
//  Practice Perfect
//
//  Created by Abigail Chen on 11/3/19.
//  Copyright © 2019 CS98 Practice Perfect. All rights reserved.
//

import SwiftUI

struct PlayMode: View {
    var body: some View {
        VStack {
            HStack{
                Text("Score")
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("Pause").foregroundColor(Color.black)
                }
            }
            
            //placeholder image here
            
            HStack {
                Text("Progress")
            }
            
        }
    }
}

struct PlayMode_Previews: PreviewProvider {
    static var previews: some View {
        PlayMode().previewLayout(.fixed(width: 896, height: 414))
    }
}
