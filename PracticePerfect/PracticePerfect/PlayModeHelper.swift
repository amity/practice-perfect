//
//  PlayModeHelper.swift
//  PracticePerfect
//  Helper file for PlayMode
//
//  Created by Anna Matusewicz on 2/20/20.
//  Copyright © 2020 CS98PracticePerfect. All rights reserved.
//
//  API functions inspired by these comments on StackOverflow:
//  https://stackoverflow.com/a/24321320
//  https://stackoverflow.com/a/26365148
//  https://stackoverflow.com/a/25622593
//
//  This link contains info on semaphores, which are necessary for loading the songs from the API:
//  https://medium.com/@michaellong/how-to-chain-api-calls-using-swift-5s-new-result-type-and-gcd-56025b51033c

import Foundation

// Whether notes should be moved up an octave or not (and therefore down an octave)
let changeUp: [Int: Bool] = [
    6: false,
    5: true,
    4: false,
    3: false,
    2: false,
    1: false,
    -1: false,
    -2: true,
    -3: false,
    -4: false,
    -5: false,
    -6: false
]

// Get MXML from API for chosen song/exercise
func getXML(url: String) -> String {
    // Retrieve song data and parse (passing score data to parseSongJson)
    let url = URL(string: url)!
    let session = URLSession.shared
    var request = URLRequest(url: url)
    request.httpMethod = "GET"

    var XMLString: String = ""
    let semaphore = DispatchSemaphore(value: 0)
    let task = session.dataTask(with: request) { data, response, error in
        // Unwrap data
        guard let unwrappedData = data else {
            print(error!)
            semaphore.signal()
            return
        }
        XMLString = String(data: unwrappedData, encoding: .utf8) ?? ""
        
        semaphore.signal()
    }
    task.resume()

    // Wait for the songs to be retrieved before displaying all of them
    _ = semaphore.wait(wallTimeout: .distantFuture)
    
    return XMLString
}


// Posts new score to API
// Posting guidance: https://stackoverflow.com/a/58804263
func postNewScore(userId: Int, songId: Int, score: Int) -> () {
    let params: [String: String] = ["song": String(songId), "user": String(userId), "score": String(score)]
    let scoreUrl = URL(string: "https://practiceperfect.appspot.com/scores")!
    let scoreSession = URLSession.shared
    var scoreRequest = URLRequest(url: scoreUrl)
    scoreRequest.httpMethod = "POST"
    scoreRequest.httpBody = try? JSONSerialization.data(withJSONObject: params)
    scoreRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let semaphore = DispatchSemaphore(value: 0)
    let task = scoreSession.dataTask(with: scoreRequest) { data, response, error in
        // TO DO: Error handling with response, currently just returns 200 which is what you would expect
        print(response!)
        semaphore.signal()
    }
    task.resume()

    _ = semaphore.wait(wallTimeout: .distantFuture)
}

// Posts score update to API
// Posting guidance: https://stackoverflow.com/a/58804263
func postScoreUpdate(scoreId: Int, score: Int) -> () {
    let params: [String: String] = ["score": String(score)]
    let scoreUrl = URL(string: "https://practiceperfect.appspot.com/scores/" + String(scoreId))!
    let scoreSession = URLSession.shared
    var scoreRequest = URLRequest(url: scoreUrl)
    scoreRequest.httpMethod = "POST"
    scoreRequest.httpBody = try? JSONSerialization.data(withJSONObject: params)
    scoreRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let semaphore = DispatchSemaphore(value: 0)
    let task = scoreSession.dataTask(with: scoreRequest) { data, response, error in
        // TO DO: Error handling with response, currently just returns 200 which is what you would expect
        print(response!)
        semaphore.signal()
    }
    task.resume()

    _ = semaphore.wait(wallTimeout: .distantFuture)
}



// Creates list of notes for transposition
func createNotesList(fifth: Int) -> Array<String> {
    let notesOrder = ["A", "B", "C", "D", "E", "F", "G"]
    let key: String = scaleOrder.reversed()[fifth + 6]
    let index = notesOrder.firstIndex(of: String(key.prefix(1)))!
   
    // Get the list of notes that have accidentals in the key signature itself
    var keySigAccidentals: [String] = []
    if fifth > 0 {
        keySigAccidentals = Array<String>(sharpOrder[0 ... fifth - 1])
    } else if fifth < 0 {
        keySigAccidentals = Array<String>(flatOrder[0 ... -fifth - 1])
    }
    
    var notesList: [String] = []
    
    // End of list
    for i in index ... notesOrder.count - 1 {
        let currNote = notesOrder[i]
        // FLAT
        // If current note has an accidental in key signature
        if keySigAccidentals.contains(currNote) {
            // If already flatted, make double flat
            if fifth < 0 {
                notesList.append(currNote + "𝄫")
            // If already sharp, make natural
            } else if fifth > 0 {
                notesList.append(currNote + "♮")
            }
        // If not accidental in key signature
        } else {
            notesList.append(currNote + "♭")
        }
        
        // NOTE ITSELF
        // If current note has accidental in key signature
        if keySigAccidentals.contains(currNote) {
            // If flatted
            if fifth < 0 {
                notesList.append(currNote + "♭")
            } else if fifth > 0 {
                notesList.append(currNote + "♯")
            }
        // If not accidental in key signature
        } else {
            notesList.append(currNote)
        }
        
        // SHARP
        // If current note has accidental in key signature
        if keySigAccidentals.contains(currNote) {
            // If already flatted, make natural
            if fifth < 0 {
                notesList.append(currNote + "♮")
            // If already sharp, make double sharp
            } else if fifth > 0 {
                notesList.append(currNote + "𝄪")
            }
        // If not accidental in key signature
        } else {
            notesList.append(currNote + "♯")
        }
    }
    // Beginning of list if not already done whole list
    if (index - 1 >= 0) {
        for j in 0 ... index - 1 {
            let currNote = notesOrder[j]
            // FLAT
            // If current note has an accidental in key signature
            if keySigAccidentals.contains(currNote) {
                // If already flatted, make double flat
                if fifth < 0 {
                    notesList.append(currNote + "𝄫")
                // If already sharp, make natural
                } else if fifth > 0 {
                    notesList.append(currNote + "♮")
                }
            // If not accidental in key signature
            } else {
                notesList.append(currNote + "♭")
            }
            
            // NOTE ITSELF
            // If current note has accidental in key signature
            if keySigAccidentals.contains(currNote) {
                // If flatted
                if fifth < 0 {
                    notesList.append(currNote + "♭")
                } else if fifth > 0 {
                    notesList.append(currNote + "♯")
                }
            // If not accidental in key signature
            } else {
                notesList.append(currNote)
            }
            
            // SHARP
            // If current note has accidental in key signature
            if keySigAccidentals.contains(currNote) {
                // If already flatted, make natural
                if fifth < 0 {
                    notesList.append(currNote + "♮")
                // If already sharp, make double sharp
                } else if fifth > 0 {
                    notesList.append(currNote + "𝄪")
                }
            // If not accidental in key signature
            } else {
                notesList.append(currNote + "♯")
            }
        }
    }
    
    return notesList
}

// Used to determine which notes should be moved up or down an octave when the key is changed
let changeOctave: [Int: [String]] = [
    6: ["C", "D", "E"],
    5: ["B"],
    4: ["C", "D"],
    3: ["C", "D", "E", "F", "G"],
    2: ["C"],
    1: ["C", "D", "E", "F"],
    0: [],
    -1: ["C", "D", "E"],
    -2: ["B"],
    -3: ["C", "D"],
    -4: ["C", "D", "E", "F", "G"],
    -5: ["C"],
    -6: ["C", "D", "E", "F"]
]

// Shifts notes depending on key
func transposeSong(originalMeasures: Array<MeasureMetadata>, halfStepOffset: Int) -> Array<MeasureMetadata> {
    // New list of transposed MeasureMetadata to be returned
    var transposed: Array<MeasureMetadata> = []
    
    // Get list of notes that will change octave after transpotiion
    let octChangeSet = Array<String>(changeOctave[halfStepOffset]!)
    
    // For each measure
    for i in 0...originalMeasures.count - 1 {
        let oldMeasure = originalMeasures[i]
        
        var transposeDict: [String: String] = [:]
        for (index, element) in createNotesList(fifth: oldMeasure.fifths).enumerated() {
            transposeDict[element] = createNotesList(fifth: oldMeasure.fifths + halfStepOffset)[index]
        }
        
        var newNotes: [NoteMetadata] = []
        
        // For each note in the measure
        for j in 0...oldMeasure.notes.count - 1 {
            let oldNote: NoteMetadata = oldMeasure.notes[j]
            var oldString: String = oldNote.step
            if oldNote.accidental != "" {
                oldString += oldNote.accidental
            } else {
                // Get the list of notes that have accidentals in the key signature itself
                var keySigAccidentals: [String] = []
                if oldMeasure.fifths > 0 {
                    keySigAccidentals = Array<String>(sharpOrder[0 ... oldMeasure.fifths - 1])
                } else if oldMeasure.fifths < 0 {
                    keySigAccidentals = Array<String>(flatOrder[0 ... -oldMeasure.fifths - 1])
                }
                
                // If accidental in key signature, add
                if keySigAccidentals.contains(oldNote.step) {
                    if oldMeasure.fifths > 0 {
                        oldString += "♯"
                    } else if oldMeasure.fifths < 0 {
                        oldString += "♭"
                    }
                }
            }
            
            let newString: String = transposeDict[oldString]!
            let newStep: String = String(newString.prefix(1))
            
            var newAccidental: String = ""
            if newString.count > 1 {
                newAccidental = String(newString.suffix(1))
            }
            
            var octChange = false
            if octChangeSet.contains(newStep) {
                octChange = true
            }
            
            var newOctave = oldNote.octave
            if octChange {
                if octChangeSet.contains(newStep) {
                    if changeUp[halfStepOffset]! {
                        newOctave -= 1
                    } else {
                        newOctave += 1
                    }
                }
            }
                        
            let newNote: NoteMetadata = NoteMetadata(step: newStep, duration: oldNote.duration, type: oldNote.type, accidental: newAccidental,
                dot: oldNote.dot, octave: newOctave, isRest: oldNote.isRest)
            newNotes.append(newNote)
        }
        
        let newMeasure = MeasureMetadata(measureNumber: oldMeasure.measureNumber, notes: newNotes, clef: oldMeasure.clef, fifths: oldMeasure.fifths + halfStepOffset, mode: oldMeasure.mode, timeSig: oldMeasure.timeSig)
        transposed.append(newMeasure)
    }
    
    return transposed
}
