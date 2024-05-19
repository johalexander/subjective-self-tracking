//
//  Participant.swift
//  Subjective Self Tracking
//
//  Created by Alexander Johansson on 18/05/2024.
//

import Foundation

struct Participant: Identifiable {
    let id = UUID()
    let age: Int
    let genderIdentity: String
    
    var completedExperiments: [Experiment]
    
    var ageString: String {
        return String(age)
    }
    
    var count: String {
        return String(completedExperiments.count)
    }
}
