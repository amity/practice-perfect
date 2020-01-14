//
//  LoginPage.swift
//  PracticePerfect
//
//  Created by Sean Hawkins on 1/14/20.
//  Copyright © 2020 CS98PracticePerfect. All rights reserved.
//

import SwiftUI

// https://stackoverflow.com/a/58242249
final class KeyboardResponder: ObservableObject {
    private var notificationCenter: NotificationCenter
    @Published private(set) var currentHeight: CGFloat = 0

    init(center: NotificationCenter = .default) {
        notificationCenter = center
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        notificationCenter.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            currentHeight = keyboardSize.height - 10
        }
    }

    @objc func keyBoardWillHide(notification: Notification) {
        currentHeight = 0
    }
}

struct LoginPage: View {
    @State var username: String = ""
    @State var password: String = ""
    
    @ObservedObject private var keyboard = KeyboardResponder()
    @State private var textFieldInput: String = ""

    var body: some View {
        ZStack {
            mainGradient

            VStack {
                Text("Enter your username and password!")
                    .font(.system(size: 30))
                    .padding(.bottom, 15)
                    .frame(width: 500)
                TextField("Username", text: $username)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .frame(width: 500)
                TextField("Password", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .frame(width: 500)
                HStack {
                    NavigationLink(destination: LandingPage()) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Login")
                                .fixedSize()
                        }
                    }
                    .modifier(MenuButtonStyle())
                    NavigationLink(destination: SignUpPage(username: username, password: password, keyboard: keyboard)) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Sign Up")
                                .fixedSize()
                        }
                    }
                    .modifier(MenuButtonStyle())
                }
            }
        }.padding(.bottom, keyboard.currentHeight)
        .edgesIgnoringSafeArea(.bottom)
        .animation(.easeOut(duration: 0.16))
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage().previewLayout(.fixed(width: 896, height: 414))
    }
}
