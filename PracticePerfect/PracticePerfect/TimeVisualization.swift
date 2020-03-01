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

//let graphHeight: Float = 100.0
let graphHeight: CGFloat = screenHeight * 0.50

struct ColorRGB {
    var red: Double
    var green: Double
    var blue: Double
}

struct CapsuleBar: View {
    var value: Int
    var maxValue: Int
    var width: CGFloat
    var valueName: String
    var capsuleColor: ColorRGB
    var body: some View {
        VStack {
            
            Text("\(value)")
            ZStack(alignment: .bottom) {
                Capsule()
                    .fill(Color.gray)
                    .opacity(0.1)
                    .frame(width: width, height: CGFloat(graphHeight))
                Capsule()
                    .fill(
                        Color(.sRGB, red: capsuleColor.red, green: capsuleColor.green, blue: capsuleColor.blue)
                    )
                    .frame(width: width, height: CGFloat(value) / CGFloat(maxValue) * CGFloat(graphHeight))
                    .animation(.easeOut(duration: 0.5))
            }
            
            Text("\(valueName)")
        }
    }
}

struct CapsuleGraphView: View {
    var data: [Int]
    var maxValueInData: Int
    var spacing: CGFloat
    var capsuleColor: ColorRGB
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                CapsuleBar(value: self.data[0],
                           maxValue: self.maxValueInData,
                           width: (CGFloat(geometry.size.width) - 8 * self.spacing) / CGFloat(self.data.count),
                           valueName: "val1",
                           capsuleColor: self.capsuleColor
                )
                CapsuleBar(value: self.data[1],
                           maxValue: self.maxValueInData,
                           width: (CGFloat(geometry.size.width) - 8 * self.spacing) / CGFloat(self.data.count),
                           valueName: "val2",
                           capsuleColor: self.capsuleColor
                )
                CapsuleBar(value: self.data[2],
                           maxValue: self.maxValueInData,
                           width: (CGFloat(geometry.size.width) - 8 * self.spacing) / CGFloat(self.data.count),
                           valueName: "val3",
                           capsuleColor: self.capsuleColor
                )
                CapsuleBar(value: self.data[3],
                           maxValue: self.maxValueInData,
                           width: (CGFloat(geometry.size.width) - 8 * self.spacing) / CGFloat(self.data.count),
                           valueName: "val4",
                           capsuleColor: self.capsuleColor
                )
                CapsuleBar(value: self.data[4],
                           maxValue: self.maxValueInData,
                           width: (CGFloat(geometry.size.width) - 8 * self.spacing) / CGFloat(self.data.count),
                           valueName: "val5",
                           capsuleColor: self.capsuleColor
                )
                CapsuleBar(value: self.data[5],
                          maxValue: self.maxValueInData,
                          width: (CGFloat(geometry.size.width) - 8 * self.spacing) / CGFloat(self.data.count),
                          valueName: "val6",
                          capsuleColor: self.capsuleColor
                )
                CapsuleBar(value: self.data[6],
                          maxValue: self.maxValueInData,
                          width: (CGFloat(geometry.size.width) - 8 * self.spacing) / CGFloat(self.data.count),
                          valueName: "val7",
                          capsuleColor: self.capsuleColor
                )

            }
        }.frame(height: CGFloat(graphHeight))
    }
}

struct TimeVisualization: View {
    @EnvironmentObject var settings: UserSettings

    private var data: [String: [Int]] = [
         "1 week": [28, 25, 30, 29, 23, 28, 21],
         "2 weeks": [3, 1, 2, 4, 3, 5, 4],
         "1 month": [2, 6, 8, 3, 4, 1, 3]
    ]
    
    @State private var dataPicker: String = "1 week"
    
    private var dataBackgroundColor: [String: ColorRGB] = [
        "1 week": ColorRGB(red: 44 / 255, green: 54 / 255, blue: 79 / 255),
        "2 weeks": ColorRGB(red: 76 / 255, green: 61 / 255, blue: 89 / 255),
        "1 month": ColorRGB(red: 56 / 255, green: 24 / 255, blue: 47 / 255)
    ]
    private var dataBarColor: [String: ColorRGB] = [
        "1 week": ColorRGB(red: 222 / 255, green: 44 / 255, blue: 41 / 255),
        "2 weeks": ColorRGB(red: 42 / 255, green: 74 / 255, blue: 150 / 255),
        "1 month": ColorRGB(red: 47 / 255, green: 57 / 255, blue: 77 / 255)
    ]
    
    var body: some View {
        ZStack {
            mainGradient
            
            HStack {
                VStack {
                    Spacer()
                    Text("Let's Graph!")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    Picker("", selection: $dataPicker) {
                        Text("1 week").tag("1 week")
                        Text("2 weeks").tag("2 weeks")
                        Text("1 month").tag("1 month")
                    }
                    .labelsHidden()
                    .frame(maxWidth: 150)
                    .clipped()
                    Spacer()
                }
                .frame(width: screenWidth * CGFloat(0.33))

                CapsuleGraphView(data: data[dataPicker]!, maxValueInData: data[dataPicker]!.max()!, spacing: 24, capsuleColor: dataBarColor[dataPicker]!)
                    .frame(width: screenWidth * CGFloat(0.67))
            }
        }
    }
}

struct TimeVisualization_Previews: PreviewProvider {
    static var previews: some View {
        TimeVisualization().previewLayout(.fixed(width: 896, height: 414))
    }
}
