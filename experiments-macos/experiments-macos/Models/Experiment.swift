//
//  Experiment.swift
//  Subjective Self Tracking
//
//  Created by Alexander Johansson on 18/05/2024.
//

import Foundation

struct Experiment: Identifiable, Codable {
    let id: String
    let experimentType: String
    var successfulStimuli: [Stimuli]
    var failedStimuli: [Stimuli]
    var startedDate: Date
    var endedDate: Date
}

struct Stimuli: Identifiable, Codable {
    let id: String
    let value: Double
    let inputType: InputType
    let sensorReading: SensorReading
}

enum InputType: String, CaseIterable, Identifiable, Codable {
    case slider
    case device
    
    var id: Self { self }
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
    
    var type: String {
        switch self {
        case .sliderGreyscale:
            return "slider_greyscale"
        case .sliderNumber:
            return "slider_number"
        case .gesturePitchGreyscale:
            return "gesture_pitch_greyscale"
        case .gesturePitchNumber:
            return "gesture_pitch_number"
        case .gestureRollGreyscale:
            return "gesture_roll_greyscale"
        case .gestureRollNumber:
            return "gesture_roll_number"
        }
    }
}
