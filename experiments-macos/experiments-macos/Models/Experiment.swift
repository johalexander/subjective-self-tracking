//
//  Experiment.swift
//  Subjective Self Tracking
//
//  Created by Alexander Johansson on 18/05/2024.
//

import Foundation

struct Experiment: Identifiable, Codable {
    let id: String
    let experimentType: ExperimentType
    var stimuliEntry: [Stimuli]
}

struct Stimuli: Identifiable, Codable {
    let id: String
    let greyscale: String
    let number: String
    let sensorReading: SensorReading
}

enum ExperimentType: Int, CaseIterable, Identifiable, Codable {
    case sliderGreyscale
    case sliderNumber
    case gesturePitchGreyscale
    case gesturePitchNumber
    case gestureRollGreyscale
    case gestureRollNumber
    
    var id: Int { self.rawValue }

    var description: String {
        switch self {
        case .sliderGreyscale:
            return "Slider - Greyscale"
        case .sliderNumber:
            return "Slider - Number"
        case .gesturePitchGreyscale:
            return "Gesture: Pitch - Greyscale"
        case .gesturePitchNumber:
            return "Gesture: Pitch - Number"
        case .gestureRollGreyscale:
            return "Gesture: Roll - Greyscale"
        case .gestureRollNumber:
            return "Roll - Number"
        }
    }
}
