//
//  LandingPage.swift
//  Practice Perfect
//
//  Created by Abigail Chen on 11/3/19.
//  Copyright © 2019 CS98 Practice Perfect. All rights reserved.
//
// Environment variable/UserDefaults use:
// https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-environmentobject-to-share-data-between-views
// https://www.hackingwithswift.com/read/12/2/reading-and-writing-basics-userdefaults
// https://medium.com/better-programming/userdefaults-in-swift-4-d1a278a0ec79
//
// isActive navigation method inspired by: https://stackoverflow.com/a/59662275


import SwiftUI

struct LandingPage: View {
    @EnvironmentObject var settings: UserSettings
    @State var isActiveSelectMusic: Bool = false
    @State var isActiveScalePicker: Bool = false
    
    @State var data: [String: [Double]] = [
        "1 week": [],
        "2 weeks": [],
        "1 month": []
    ]
    @State var streakLength: Int = 0
    
    let note: some View = Image("note").resizable().frame(width: 75, height: 75)
    let smallNote: some View = Image("note").resizable().frame(width: 50, height: 50)
    
    @State var loggedOut: Bool
    
    var body: some View {
        ZStack {
            mainGradient
            
            VStack {
                HStack {
                    Spacer()
                    smallNote
                    note
                }
                HStack {
                    Spacer()
                    smallNote
                }
                Spacer()
                HStack {
                    smallNote
                    Spacer()
                }
                HStack {
                    note
                    smallNote
                    Spacer()
                }
            }
            VStack {
                ZStack {
                    Image("full-logo")
                    if self.streakLength > 0 {
                        VStack {
                            Text("\(self.streakLength) day streak!")
                                .font(.title)
                                .offset(x: screenWidth * 0.044 , y: screenWidth * 0.044)
                        }
                    }
                }
                
                HStack {
                    NavigationLink(destination: SelectMusic(rootIsActive: self.$isActiveSelectMusic), isActive: self.$isActiveSelectMusic) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Play!")
                                .fixedSize()
                        }
                    }
                    .isDetailLink(false)
                    .modifier(MenuButtonStyle())
                    
                    NavigationLink(destination: TunerView()) {
                        HStack {
                            Image(systemName: "tuningfork")
                            Text("Tuner")
                                .fixedSize()
                        }
                    }
                    .modifier(MenuButtonStyle())
                    
                    NavigationLink(destination: TimeVisualization(data: self.data)) {
                        HStack {
                            Image(systemName: "gobackward")
                            Text("History")
                                .fixedSize()
                        }
                    }
                    .modifier(MenuButtonStyle())
                }
                
                HStack {
                    NavigationLink(destination: ScalePicker(rootIsActive: self.$isActiveScalePicker),
                        isActive: self.$isActiveScalePicker) {
                        HStack {
                            Image(systemName: "music.note")
                            Text("Exercises")
                                .fixedSize()
                        }
                    }
                    .isDetailLink(false)
                    .modifier(MenuButtonStyle())
                    
                    NavigationLink(destination: SettingsView(loggedOut: self.$loggedOut, selectedClef: settings.clefIndex, selectedKey: settings.keyIndex)) {
                        HStack {
                            Image(systemName: "gear")
                            Text("Settings")
                                .fixedSize()
                        }
                    }
                    .modifier(MenuButtonStyle())
                }
                
                NavigationLink(destination: LoginPage(), isActive: $loggedOut) {
                    EmptyView()
                }
            }
            .navigationBarTitle(settings.username ?? "")
            .navigationBarBackButtonHidden(true)
        }
        .onAppear() {
            // Get data to pass to visualization
            if self.settings.dailyTimes != nil {
                if (self.settings.dailyTimes! as? [Double])!.contains(0) {
                    let lastZero: Int = Array<Double>((self.settings.dailyTimes! as? [Double])!).lastIndex(of: 0)! + 1
                    self.streakLength = Array<Double>((self.settings.dailyTimes! as? [Double])![lastZero ... self.settings.dailyTimes!.count - 1]).count
                } else {
                    self.streakLength = self.settings.dailyTimes!.count
                }
                
                if self.settings.dailyTimes!.count > 28 {
                    self.data.updateValue(Array<Double>((self.settings.dailyTimes! as? [Double])![self.settings.dailyTimes!.count - 7 ... self.settings.dailyTimes!.count - 1]), forKey: "1 week")
                    self.data.updateValue(Array<Double>((self.settings.dailyTimes! as? [Double])![self.settings.dailyTimes!.count - 14 ... self.settings.dailyTimes!.count - 1]), forKey: "2 weeks")
                    self.data.updateValue(Array<Double>((self.settings.dailyTimes! as? [Double])![self.settings.dailyTimes!.count - 28 ... self.settings.dailyTimes!.count - 1]), forKey: "1 month")
                } else if self.settings.dailyTimes!.count > 14 {
                    self.data.updateValue(Array<Double>((self.settings.dailyTimes! as? [Double])![self.settings.dailyTimes!.count - 7 ... self.settings.dailyTimes!.count - 1]), forKey: "1 week")
                    self.data.updateValue(Array<Double>((self.settings.dailyTimes! as? [Double])![self.settings.dailyTimes!.count - 14 ... self.settings.dailyTimes!.count - 1]), forKey: "2 weeks")
                    self.data.updateValue((Array<Double>(Array(repeating: 0, count: 28 - self.settings.dailyTimes!.count)) + self.settings.dailyTimes! as? [Double])!, forKey: "1 month")
                } else if self.settings.dailyTimes!.count > 7 {
                    self.data.updateValue(Array<Double>((self.settings.dailyTimes! as? [Double])![self.settings.dailyTimes!.count - 7 ... self.settings.dailyTimes!.count - 1]), forKey: "1 week")
                    self.data.updateValue((Array<Double>(Array(repeating: 0, count: 14 - self.settings.dailyTimes!.count)) + self.settings.dailyTimes! as? [Double])!, forKey: "2 weeks")
                    self.data.updateValue((Array<Double>(Array(repeating: 0, count: 28 - self.settings.dailyTimes!.count)) + self.settings.dailyTimes! as? [Double])!, forKey: "1 month")
                } else {
                    self.data.updateValue((Array<Double>(Array(repeating: 0, count: 7 - self.settings.dailyTimes!.count)) + self.settings.dailyTimes! as? [Double])!, forKey: "1 week")
                    self.data.updateValue((Array<Double>(Array(repeating: 0, count: 14 - self.settings.dailyTimes!.count)) + self.settings.dailyTimes! as? [Double])!, forKey: "2 weeks")
                    self.data.updateValue((Array<Double>(Array(repeating: 0, count: 28 - self.settings.dailyTimes!.count)) + self.settings.dailyTimes! as? [Double])!, forKey: "1 month")
                }
            } else {
                self.data.updateValue(Array<Double>(Array(repeating: 0, count: 7)), forKey: "1 week")
                self.data.updateValue(Array<Double>(Array(repeating: 0, count: 14)), forKey: "2 weeks")
                self.data.updateValue(Array<Double>(Array(repeating: 0, count: 28)), forKey: "1 month")
            }
        }
    }
}

struct LandingPage_Previews: PreviewProvider {
    static var previews: some View {
        LandingPage(loggedOut: false).previewLayout(.fixed(width: 896, height: 414))
    }
}
