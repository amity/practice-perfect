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

// Color Palette:
let baseBlue = Color(red: 184.0/255.0, green: 234.0/255.0, blue: 252.0/255.0)

let aquaBlue = Color(red: 109.0/255.0, green: 214.0/255.0, blue: 253.0/255.0)
let lightGreen = Color(red: 180.0/255.0, green: 204.0/255.0, blue: 110.0/255.0)
let darkGreen = Color(red: 160.0/255.0, green: 179.0/255.0, blue: 105.0/255.0)
let darkRed = Color(red: 255.0/255.0, green: 0/255.0, blue: 0/255.0)
let lightRed = Color(red: 255.0/255.0, green: 153.0/255.0, blue: 153.0/255.0)

struct NoteNameStyle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .foregroundColor(Color.black)
            .font(Font.system(size: 90).weight(.bold))
    }
}

struct AccidentalStyle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .foregroundColor(Color.black)
            .font(Font.largeTitle.weight(.bold))
    }
}

struct ButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .padding()
            .foregroundColor(.black)
            .font(Font.headline.weight(.bold))
            .background(LinearGradient(gradient: Gradient(colors: [.gray, .white]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(40)
    }
}

struct MenuButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .padding()
            .foregroundColor(.white)
            .font(Font.headline.weight(.bold))
            .background(LinearGradient(gradient: Gradient(colors: [darkGreen, lightGreen]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(40)
    }
}

struct MenuButtonStyleRed: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .padding()
            .foregroundColor(.white)
            .font(Font.headline.weight(.bold))
            .background(LinearGradient(gradient: Gradient(colors: [darkRed, lightRed]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(40)
    }
}

struct NoteStyle: ViewModifier {
    let offset: Int
    let scrollOffset: Float
    let opacity: Double
    
    func body(content: Content) -> some View {
        return content
            .frame(width: 30.0, height: 30.0)
            .offset(x: CGFloat(scrollOffset), y: CGFloat(-75 + offset))
            .opacity(opacity)
    }
}

struct TailStyle: ViewModifier {
    let offset: Int
    let scrollOffset: Float
    let opacity: Double
    let facingUp: Bool
    
    func body(content: Content) -> some View {
        let yConstant = self.facingUp ? -105 : -45
        let xConstant = Float(self.facingUp ? 15 : -15)

        return content
            .frame(width: 4.0, height: 60.0)
            .offset(x: CGFloat(scrollOffset + xConstant), y: CGFloat(offset + yConstant))
            .opacity(opacity)
    }
}

struct FlagStyle: ViewModifier {
    let offset: Int
    let scrollOffset: Float
    let opacity: Double
    let facingUp: Bool
    let position: Int
    
    func body(content: Content) -> some View {
        let yConstant = self.facingUp ? -133 : -17
        let xConstant = Float(self.facingUp ? 23 : -23)
        let positionConstant = self.facingUp ? position * 10 : position * -10

        return content
            .frame(width: 14.0, height: 4.0)
            .offset(x: CGFloat(scrollOffset + xConstant), y: CGFloat(offset + yConstant + positionConstant))
            .opacity(opacity)
    }
}

struct LedgerStyle: ViewModifier {
    let offset: Int
    let scrollOffset: Float
    let opacity: Double
    
    func body(content: Content) -> some View {
        return content
            .frame(width: 50.0, height: 1.0)
            .offset(x: CGFloat(scrollOffset), y: CGFloat(-75 + offset))
            .opacity(opacity)
    }
}

struct NoteDotStyle: ViewModifier {
    let offset: Int
    let scrollOffset: Float
    let opacity: Double
    
    func body(content: Content) -> some View {
        return content
            .frame(width: 10.0, height: 10.0)
            .offset(x: CGFloat(scrollOffset + -10), y: CGFloat(-75 + offset))
            .opacity(opacity)
    }
}

struct KeyStyle: ViewModifier {
    let offset: Int
    
    func body(content: Content) -> some View {
        return content
            .padding(.horizontal, 0)
            .font(.system(size: 30))
            .frame(width: 20.0, height: 20.0)
            .offset(y: CGFloat(-75 + offset))
    }
}

struct RestStyle: ViewModifier {
    let offset: Int
    let scrollOffset: Float
    let opacity: Double
    
    func body(content: Content) -> some View {
        return content
            .offset(x: CGFloat(scrollOffset), y: CGFloat(-75 + offset))
            .opacity(opacity)
    }
}

struct AccidentalScrollStyle: ViewModifier {
    let offset: Int
    let scrollOffset: Float
    let opacity: Double
    
    func body(content: Content) -> some View {
        return content
            .font(.title)
            .offset(x: CGFloat(-25 + scrollOffset), y: CGFloat(-75 + offset))
            .opacity(opacity)
    }
}
