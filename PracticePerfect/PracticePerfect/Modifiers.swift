//
//  Modifiers.swift
//  PracticePerfect
//
//  Created by Anna Matusewicz on 11/17/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//

import SwiftUI

// Gradients

let mainGradient: some View = LinearGradient(gradient: Gradient(colors: [
        aquaBlue,
        baseBlue,
        aquaBlue
    ]), startPoint: .leading, endPoint: .trailing)
        .edgesIgnoringSafeArea(.all)

// Color:
let baseBlue = Color(red: 184.0/255.0, green: 234.0/255.0, blue: 252.0/255.0)

let mutedBlue = Color(red: 156.0/255.0, green: 191.0/255.0, blue: 230.0/255.0)
let purpleBlue = Color(red: 173.0/255.0, green: 189.0/255.0, blue: 254.0/255.0)
let aquaBlue = Color(red: 109.0/255.0, green: 214.0/255.0, blue: 253.0/255.0)
let lightGreen = Color(red: 180.0/255.0, green: 204.0/255.0, blue: 110.0/255.0)
let darkGreen = Color(red: 160.0/255.0, green: 179.0/255.0, blue: 105.0/255.0)

struct ScaleStyle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .foregroundColor(Color.black)
            .font(Font.custom("Arial Rounded MT Bold", size: 18))
            .padding(.leading, 20)
    }
}

struct NoteStyle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .foregroundColor(Color.black)
            .font(Font.custom("Arial Rounded MT Bold", size: 100))
    }
}

struct AccidentalStyle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .foregroundColor(Color.black)
            .font(Font.custom("Arial Rounded MT Bold", size: 50))
    }
}

struct ButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .padding()
            .foregroundColor(.black)
            .font(Font.custom("Arial Rounded MT Bold", size: 18))
            .background(LinearGradient(gradient: Gradient(colors: [.gray, .white]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(40)
    }
}

struct MenuButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .padding()
            .foregroundColor(.white)
            .font(Font.custom("Arial Rounded MT Bold", size: 18))
            .background(LinearGradient(gradient: Gradient(colors: [darkGreen, lightGreen]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(40)
    }
}
