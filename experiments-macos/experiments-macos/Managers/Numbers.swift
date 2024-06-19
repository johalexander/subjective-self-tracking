//
//  Numbers.swift
//  Subjective Self Tracking
//
//  Created by Alexander Johansson on 18/05/2024.
//

import Foundation
import SwiftUI

class Numbers {
    private let generatedNumbers = [Int](0...100)
    
    private var queuedNumbers: [Int]
    private var trialNumbers: [Int]
    
    var currentNumber: String {
        let num = self.queuedNumbers.last ?? 0
        return String(num)
    }
    
    var currentTrialNumber: String {
        let num = self.trialNumbers.last ?? 0
        return String(num)
    }
    
    func consume() {
        self.queuedNumbers.removeLast()
        if self.queuedNumbers.isEmpty {
            self.queuedNumbers = self.generatedNumbers.shuffled()
        }
    }
    
    func consumeTrial() {
        self.trialNumbers.removeLast()
        if self.trialNumbers.isEmpty {
            self.trialNumbers = self.generatedNumbers.shuffled()
        }
    }
    
    init() {
        self.queuedNumbers = self.generatedNumbers.shuffled()
        self.trialNumbers = self.generatedNumbers.shuffled()
    }
}
