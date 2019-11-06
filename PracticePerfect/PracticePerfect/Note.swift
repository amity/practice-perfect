//
//  Note.swift
//  PracticePerfect
//
//  Created by Anna Matusewicz on 11/5/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//

import Foundation

// Written following a tutorial found at:
// http://shinerightstudio.com/posts/ios-tuner-app-using-audiokit/
class Note: Equatable {
    enum Accidental: Int { case natural = 0, sharp, flat }
    enum Name: Int { case a = 0, b, c, d, e, f, g }
    
    // All the 12 notes in an octave.
    static let all: [Note] = [
        Note(.c, .natural), Note(.c, .sharp),
        Note(.d, .natural),
        Note(.e, .flat), Note(.e, .natural),
        Note(.f, .natural), Note(.f, .sharp),
        Note(.g, .natural),
        Note(.a, .flat), Note(.a, .natural),
        Note(.b, .flat), Note(.b, .natural)
    ]
    
    var note: Name
    var accidental: Accidental
    
    // Initializer.
    init(_ note: Name, _ accidental: Accidental) {
        self.note = note
        self.accidental = accidental
    }

    // Equality operators.
    static func ==(lhs: Note, rhs: Note) -> Bool {
        return lhs.note == rhs.note && lhs.accidental == rhs.accidental
    }
    
    static func !=(lhs: Note, rhs: Note) -> Bool {
        return !(lhs == rhs)
    }
    
    var frequency: Double {
        let index = Note.all.firstIndex(of: self)! - Note.all.firstIndex(of: Note(.a, .natural))!
         return 440.0 * pow(2.0, Double(index) / 12.0)
    }
}
