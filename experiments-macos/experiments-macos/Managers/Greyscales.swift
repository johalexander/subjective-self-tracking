//
//  Greyscales.swift
//  Subjective Self Tracking
//
//  Created by Alexander Johansson on 18/05/2024.
//

import Foundation
import SwiftUI

class Greyscales {
    private let generatedColors = [
        Scale(id: 0, color: Color(red: 255, green: 255, blue: 255)),
        Scale(id: 1, color: Color(red: 249/255, green: 249/255, blue: 249/255)),
        Scale(id: 2, color: Color(red: 243/255, green: 243/255, blue: 243/255)),
        Scale(id: 3, color: Color(red: 237/255, green: 237/255, blue: 237/255)),
        Scale(id: 4, color: Color(red: 232/255, green: 232/255, blue: 232/255)),
        Scale(id: 5, color: Color(red: 226/255, green: 226/255, blue: 226/255)),
        Scale(id: 6, color: Color(red: 220/255, green: 220/255, blue: 220/255)),
        Scale(id: 7, color: Color(red: 214/255, green: 214/255, blue: 214/255)),
        Scale(id: 8, color: Color(red: 209/255, green: 209/255, blue: 209/255)),
        Scale(id: 9, color: Color(red: 203/255, green: 203/255, blue: 203/255)),
        Scale(id: 0, color: Color(red: 197/255, green: 197/255, blue: 197/255)),
        Scale(id: 10, color: Color(red: 192/255, green: 192/255, blue: 192/255)),
        Scale(id: 11, color: Color(red: 186/255, green: 186/255, blue: 186/255)),
        Scale(id: 12, color: Color(red: 180/255, green: 180/255, blue: 180/255)),
        Scale(id: 13, color: Color(red: 175/255, green: 175/255, blue: 175/255)),
        Scale(id: 14, color: Color(red: 169/255, green: 169/255, blue: 169/255)),
        Scale(id: 15, color: Color(red: 164/255, green: 164/255, blue: 164/255)),
        Scale(id: 16, color: Color(red: 159/255, green: 159/255, blue: 159/255)),
        Scale(id: 17, color: Color(red: 153/255, green: 153/255, blue: 153/255)),
        Scale(id: 18, color: Color(red: 148/255, green: 148/255, blue: 148/255)),
        Scale(id: 19, color: Color(red: 142/255, green: 142/255, blue: 142/255)),
        Scale(id: 20, color: Color(red: 137/255, green: 137/255, blue: 137/255)),
        Scale(id: 21, color: Color(red: 132/255, green: 132/255, blue: 132/255)),
        Scale(id: 22, color: Color(red: 127/255, green: 127/255, blue: 127/255)),
        Scale(id: 23, color: Color(red: 121/255, green: 121/255, blue: 121/255)),
        Scale(id: 24, color: Color(red: 116/255, green: 116/255, blue: 116/255)),
        Scale(id: 25, color: Color(red: 111/255, green: 111/255, blue: 111/255)),
        Scale(id: 26, color: Color(red: 106/255, green: 106/255, blue: 106/255)),
        Scale(id: 27, color: Color(red: 101/255, green: 101/255, blue: 101/255)),
        Scale(id: 28, color: Color(red: 96/255, green: 96/255, blue: 96/255)),
        Scale(id: 29, color: Color(red: 91/255, green: 91/255, blue: 91/255)),
        Scale(id: 30, color: Color(red: 86/255, green: 86/255, blue: 86/255)),
        Scale(id: 31, color: Color(red: 82/255, green: 82/255, blue: 82/255)),
        Scale(id: 32, color: Color(red: 77/255, green: 77/255, blue: 77/255)),
        Scale(id: 33, color: Color(red: 72/255, green: 72/255, blue: 72/255)),
        Scale(id: 34, color: Color(red: 67/255, green: 67/255, blue: 67/255)),
        Scale(id: 35, color: Color(red: 63/255, green: 63/255, blue: 63/255)),
        Scale(id: 36, color: Color(red: 58/255, green: 58/255, blue: 58/255)),
        Scale(id: 37, color: Color(red: 53/255, green: 53/255, blue: 53/255)),
        Scale(id: 38, color: Color(red: 47/255, green: 47/255, blue: 47/255)),
        Scale(id: 39, color: Color(red: 43/255, green: 43/255, blue: 43/255)),
        Scale(id: 40, color: Color(red: 39/255, green: 39/255, blue: 39/255)),
        Scale(id: 41, color: Color(red: 34/255, green: 34/255, blue: 34/255)),
        Scale(id: 42, color: Color(red: 32/255, green: 32/255, blue: 32/255)),
        Scale(id: 43, color: Color(red: 32/255, green: 32/255, blue: 32/255)),
        Scale(id: 44, color: Color(red: 28/255, green: 28/255, blue: 28/255)),
        Scale(id: 45, color: Color(red: 24/255, green: 24/255, blue: 24/255)),
        Scale(id: 46, color: Color(red: 20/255, green: 20/255, blue: 20/255)),
        Scale(id: 47, color: Color(red: 14/255, green: 14/255, blue: 14/255)),
        Scale(id: 48, color: Color(red: 7/255, green: 7/255, blue: 7/255)),
        Scale(id: 49, color: Color(red: 0, green: 0, blue: 0)),
    ]
    
    private var queuedColors: [Scale]
    private var trialColors: [Scale]
    
    var currentColor: Scale? {
        return self.queuedColors.last
    }
    
    var currentTrialColor: Scale? {
        return self.trialColors.last
    }
    
    func consume() {
        self.queuedColors.removeLast()
        if self.queuedColors.isEmpty {
            self.queuedColors = self.generatedColors.shuffled()
        }
    }
    
    func consumeTrial() {
        self.trialColors.removeLast()
        if self.trialColors.isEmpty {
            self.trialColors = self.generatedColors.shuffled()
        }
    }
    
    init() {
        self.queuedColors = self.generatedColors.shuffled()
        self.trialColors = self.generatedColors.shuffled()
    }
}

struct Scale {
    var id: Int
    var color: Color
}
