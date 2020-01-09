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
class Note: Equatable, Hashable {
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
    
    // Hash function
    func hash(into hasher: inout Hasher) {
        hasher.combine(note)
        hasher.combine(accidental)
    }
    
    var frequency: Double {
        let index = Note.all.firstIndex(of: self)! - Note.all.firstIndex(of: Note(.a, .natural))!
        return 440.0 * pow(2.0, Double(index) / 12.0)
    }
    
    var halfStepDown: Note {
        let selfIndex = Note.all.firstIndex(of: Note(note, accidental))
        if selfIndex != 0 {
            return Note.all[selfIndex! - 1]
        }
        else {
            return Note.all.last!
        }
    }
    
    var halfStepUp: Note {
        let selfIndex = Note.all.firstIndex(of: Note(note, accidental))
        if selfIndex != (Note.all.count - 1) {
            return Note.all[selfIndex! + 1]
        }
        else {
            return Note.all.first!
        }
    }
}
