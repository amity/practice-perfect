//
//  TimeVisualization.swift
//  PracticePerfect
//
//  Created by Sean Hawkins on 3/1/20.
//  Copyright © 2020 CS98PracticePerfect. All rights reserved.
//
// Inspired by the following graphing tutorials:
// https://medium.com/better-programming/how-to-draw-beautifully-animated-graphs-in-swiftui-part-1-8688c38a2db0
// https://medium.com/better-programming/how-to-draw-beautifully-animated-graphs-in-swiftui-part-2-597d7e1ef79e
// https://medium.com/better-programming/how-to-draw-beautifully-animated-graphs-in-swiftui-part-1-9f8c26011071

import SwiftUI

let days = ["Su", "M", "Tu", "W", "Th", "F", "Sa"]

// Inspired by: https://stackoverflow.com/a/25533357
func getDayOfWeek() -> String {
    let myCalendar = Calendar(identifier: .gregorian)
    let weekDay = myCalendar.component(.weekday, from: Date())
    return days[weekDay - 1]
}

//let graphHeight: Float = 100.0
let graphHeight: CGFloat = screenHeight * 0.50

struct ColorRGB {
    var red: Double
    var green: Double
    var blue: Double
}

struct CapsuleBar: View {
    var value: Double
    var maxValue: Double
    var width: CGFloat
    var valueName: String
    var capsuleColor: ColorRGB
    var showValue: Bool
    var showWeekday: Bool
    
    var body: some View {
        VStack {
            if showValue {
                if value == 0.0 {
                    Text("0")
                } else if value < 1 {
                    Text("1")
                } else {
                    Text("\(Int(ceil(value)))")
                }
            }
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(Color.gray)
                    .opacity(0.1)
                    .frame(width: width, height: CGFloat(graphHeight))
                if maxValue > 0 {
                    Rectangle()
                        .fill(
                            Color(.sRGB, red: capsuleColor.red, green: capsuleColor.green, blue: capsuleColor.blue)
                        )
                        .frame(width: width, height: CGFloat(value) / CGFloat(maxValue) * CGFloat(graphHeight))
//                        .animation(.easeOut(duration: 0.5))
                } else {
                    Rectangle()
                        .fill(
                            Color(.sRGB, red: capsuleColor.red, green: capsuleColor.green, blue: capsuleColor.blue)
                        )
                        .frame(width: width, height: CGFloat(value) / CGFloat(graphHeight))
//                        .animation(.easeOut(duration: 0.5))
                }
            }
            
            if self.showWeekday {
                Text("\(valueName)")
            }
        }
    }
}

func createCapsule(value: Double, maxValueInData: Double, width: CGFloat, valueName: String, capsuleColor: ColorRGB, showValue: Bool, showWeekday: Bool) -> some View {
        
    // Convert from seconds to minutes, ensure that nothing is below 1
    var newValue = value / 60.0
    var newMaxValue = maxValueInData / 60.0
    if newValue < 1 && newValue != 0 {
        newValue = 1
    }
    if newMaxValue < 1 && newMaxValue != 0 {
        newMaxValue = 1
    }
    newValue = Double(Int(newValue))
    newMaxValue = Double(Int(newMaxValue))
    
    return Group {
        CapsuleBar(value: newValue, maxValue: newMaxValue, width: width, valueName: valueName, capsuleColor: capsuleColor, showValue: showValue, showWeekday: showWeekday)
    }
}

struct CapsuleGraphView: View {
    var data: [Double]
    var maxValueInData: Double
    var spacing: CGFloat
    var capsuleColor: ColorRGB
    var showValue: Bool
    var showWeekday: Bool
    var weekday: String
    @State var weekdayIndex: Int = 0
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                if self.data.count > 7 {
                    ForEach(0 ..< self.data.count, id: \.self) { index in
                        createCapsule(value: self.data[index], maxValueInData: self.maxValueInData, width: (CGFloat(geometry.size.width) - 8 * self.spacing) / CGFloat(self.data.count), valueName: days[(self.weekdayIndex + index + 1) % 7], capsuleColor: self.capsuleColor, showValue: self.showValue, showWeekday: self.showWeekday)
                    }
                } else {
                    ForEach(0 ..< self.data.count, id: \.self) { index in
                        createCapsule(value: self.data[index], maxValueInData: self.maxValueInData, width: (CGFloat(geometry.size.width) - 8 * self.spacing) / CGFloat(self.data.count), valueName: days[(self.weekdayIndex + index + 1) % 7], capsuleColor: self.capsuleColor, showValue: self.showValue, showWeekday: self.showWeekday)
                    }
                }
            }
        }.frame(height: CGFloat(graphHeight))
        .onAppear() {
            self.weekdayIndex = days.firstIndex(of: self.weekday)!
        }
    }
}

struct TimeVisualization: View {
    @EnvironmentObject var settings: UserSettings
  
    var data: [String: [Double]]
    
    var weekday = getDayOfWeek()
    
    @State private var dataPicker: String = "1 week"
    
    var dataBackgroundColor: [String: ColorRGB] = [
        "1 week": ColorRGB(red: 44 / 255, green: 54 / 255, blue: 79 / 255),
        "2 weeks": ColorRGB(red: 76 / 255, green: 61 / 255, blue: 89 / 255),
        "1 month": ColorRGB(red: 56 / 255, green: 24 / 255, blue: 47 / 255)
    ]
    var dataBarColor: [String: ColorRGB] = [
        "1 week": ColorRGB(red: 222 / 255, green: 44 / 255, blue: 41 / 255),
        "2 weeks": ColorRGB(red: 42 / 255, green: 74 / 255, blue: 150 / 255),
        "1 month": ColorRGB(red: 47 / 255, green: 57 / 255, blue: 77 / 255)
    ]
    
    var body: some View {
        ZStack {
            mainGradient
            
            HStack {
                Spacer()
                
                VStack {
                    Spacer()
                    Text("Minutes Practiced\nPer Day")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Picker("", selection: $dataPicker) {
                        Text("1 week").tag("1 week")
                        Text("2 weeks").tag("2 weeks")
                        Text("1 month").tag("1 month")
                    }
                    .labelsHidden()
                    .frame(maxWidth: 150, maxHeight: 150)
                    .clipped()
                    Spacer()
                }
                .frame(width: screenWidth * CGFloat(0.33))

                if data[dataPicker]!.count > 14 {
                    CapsuleGraphView(data: data[dataPicker]!, maxValueInData: data[dataPicker]!.max()!, spacing: 50, capsuleColor: dataBarColor[dataPicker]!, showValue: false, showWeekday: false, weekday: weekday)
                        .frame(width: screenWidth * CGFloat(0.67))
                } else if data[dataPicker]!.count > 7 {
                    CapsuleGraphView(data: data[dataPicker]!, maxValueInData: data[dataPicker]!.max()!, spacing: 37.5, capsuleColor: dataBarColor[dataPicker]!, showValue: false, showWeekday: true, weekday: weekday)
                        .frame(width: screenWidth * CGFloat(0.67))
                } else {
                    CapsuleGraphView(data: data[dataPicker]!, maxValueInData: data[dataPicker]!.max()!, spacing: 25, capsuleColor: dataBarColor[dataPicker]!, showValue: true, showWeekday: true, weekday: weekday)
                    .frame(width: screenWidth * CGFloat(0.67))
                }
                
                Spacer()
            }
        }
    }
}

struct TimeVisualization_Previews: PreviewProvider {
    static var previews: some View {
        TimeVisualization(data: ["test" : [10]]).previewLayout(.fixed(width: 896, height: 414))
    }
}
