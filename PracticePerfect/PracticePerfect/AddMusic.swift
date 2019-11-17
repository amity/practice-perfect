//
//  AddMusic.swift
//  Practice Perfect
//
//  Created by Abigail Chen on 11/3/19.
//  Copyright © 2019 CS98 Practice Perfect. All rights reserved.
//

import SwiftUI

struct AddMusic: View {
    var body: some View {
        ZStack {
            mainGradient
            VStack{
                Text("Add Music")
            
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                                Text("Upload music: ")
                }
            }
        }
    }
}

struct AddMusic_Previews: PreviewProvider {
    static var previews: some View {
        AddMusic().previewLayout(.fixed(width: 896, height: 414))
    }
}
