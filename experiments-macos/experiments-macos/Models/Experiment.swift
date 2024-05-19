//
//  Experiment.swift
//  Subjective Self Tracking
//
//  Created by Alexander Johansson on 18/05/2024.
//

import Foundation

struct Experiment: Identifiable {
    let id = UUID()
    let experimentType: ExperimentType
}

enum ExperimentType {
    case sliderGreyscale
    case sliderNumber
    case gesturePitchGreyscale
    case gesturePitchNumber
    case gestureRollGreyscale
    case gestureRollNumber
}
