//
//  SelectMusic.swift
//  Practice Perfect
//
//  Created by Abigail Chen on 11/3/19.
//  Copyright © 2019 CS98 Practice Perfect. All rights reserved.
//

import SwiftUI

struct SelectMusic: View {
    var body: some View {
        VStack {
            HStack {
                //align top of page
                Text("Select Music")
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("New Music").foregroundColor(Color.black)
                }
            }

            HStack{
                //horizontal scrolling here
                ScrollView {
                    Text("Song1")
                    Text("Song2")
                    Text("Song3")
                }
            }
        }
        .navigationBarTitle("Select Music")
    }
}

struct SelectMusic_Previews: PreviewProvider {
    static var previews: some View {
        SelectMusic().previewLayout(.fixed(width: 896, height: 414))
    }
}
