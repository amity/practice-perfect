//
//  Data.swift
//  PracticePerfect
//
//  Created by Anna Matusewicz on 11/11/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//
// File adapted from lists tutorial:
// https://developer.apple.com/tutorials/swiftui/building-lists-and-navigation

import UIKit
import SwiftUI
import CoreLocation

let musicData: Dictionary<String, [ScaleMetadata]> = load("Exercises.json")

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
