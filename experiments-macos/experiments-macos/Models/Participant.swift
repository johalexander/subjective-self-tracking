//
//  Participant.swift
//  Subjective Self Tracking
//
//  Created by Alexander Johansson on 18/05/2024.
//

import Foundation

struct Participant: Identifiable, Codable {
    var id: String
    let age: String
    let genderIdentity: String
    let email: String
    let questionnaireOptIn: Bool
    
    var completedExperiments: [Experiment]
    
    var totalExperimentCount: String {
        return String(completedExperiments.count)
    }
    
    var totalStimuliCount: String {
        return String(completedExperiments.reduce(0) { $0 + $1.stimuliEntry.count })
    }
}

enum Gender: String, CaseIterable, Identifiable {
    case male
    case female
    case other
    case undisclosed
    
    var id: Self { self }
}
