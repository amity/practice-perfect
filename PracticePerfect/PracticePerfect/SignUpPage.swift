//
//  LoginPage.swift
//  PracticePerfect
//
//  Created by Sean Hawkins on 1/14/20.
//  Copyright © 2020 CS98PracticePerfect. All rights reserved.
//

import SwiftUI

// https://stackoverflow.com/a/58242249

struct SignUpPage: View {
    @State var name: String = ""
    @State var email: String = ""
    @State var username: String
    @State var password: String
    
    @ObservedObject var keyboard: KeyboardResponder
    @State private var textFieldInput: String = ""

    var body: some View {
        ZStack {
            mainGradient

            VStack {
                Text("Enter your information below!")
                    .padding(.bottom, 15)
                    .font(.largeTitle)
                    .frame(width: 500)
                HStack {
                    TextField("Name", text: $name)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                        .frame(width: 300)
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                        .frame(width: 300)
                }
                HStack {
                    TextField("Username (optional)", text: $username)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                        .frame(width: 300)
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                        .frame(width: 300)
                }
                HStack {
                    NavigationLink(destination: LandingPage()) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Create Account")
                        }
                    }
                    .modifier(MenuButtonStyle())
                }
            }
        }
        .foregroundColor(.black)
        .padding(.bottom, keyboard.currentHeight)
        .edgesIgnoringSafeArea(.bottom)
        .animation(.easeOut(duration: 0.16))
    }
}

struct SignUpPage_Previews: PreviewProvider {
    static var previews: some View {
        SignUpPage(username: "username", password: "password", keyboard: KeyboardResponder()).previewLayout(.fixed(width: 896, height: 414))
    }
}
