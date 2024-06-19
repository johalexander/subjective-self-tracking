//
//  LatinSquare.swift
//  Subjective Self Tracking
//
//  Created by Alexander Johansson on 19/05/2024.
//

import Foundation

func generateLatinSquare(size: Int) -> [[Int]] {
    var latinSquare: [[Int]] = Array(repeating: Array(repeating: 0, count: size), count: size)
    for i in 0..<size {
        for j in 0..<size {
            latinSquare[i][j] = (i + j) % size
        }
    }
    return latinSquare
}

func saveParticipantCount(_ count: Int) {
    let filename = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("participant_count.txt")
    do {
        try String(count).write(to: filename, atomically: true, encoding: .utf8)
        print("Participant count saved: \(count)")
    } catch {
        print("Failed to save participant count: \(error)")
    }
}

func readParticipantCount() -> Int {
    let filename = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("participant_count.txt")
    if let countString = try? String(contentsOf: filename), let count = Int(countString) {
        return count
    } else {
        return 0
    }
}
