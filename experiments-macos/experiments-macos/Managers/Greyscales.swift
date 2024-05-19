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
        Color(red: 255, green: 255, blue: 255),
        Color(red: 249/255, green: 249/255, blue: 249/255),
        Color(red: 243/255, green: 243/255, blue: 243/255),
        Color(red: 237/255, green: 237/255, blue: 237/255),
        Color(red: 232/255, green: 232/255, blue: 232/255),
        Color(red: 226/255, green: 226/255, blue: 226/255),
        Color(red: 220/255, green: 220/255, blue: 220/255),
        Color(red: 214/255, green: 214/255, blue: 214/255),
        Color(red: 209/255, green: 209/255, blue: 209/255),
        Color(red: 203/255, green: 203/255, blue: 203/255),
        Color(red: 197/255, green: 197/255, blue: 197/255),
        Color(red: 192/255, green: 192/255, blue: 192/255),
        Color(red: 186/255, green: 186/255, blue: 186/255),
        Color(red: 180/255, green: 180/255, blue: 180/255),
        Color(red: 175/255, green: 175/255, blue: 175/255),
        Color(red: 169/255, green: 169/255, blue: 169/255),
        Color(red: 164/255, green: 164/255, blue: 164/255),
        Color(red: 159/255, green: 159/255, blue: 159/255),
        Color(red: 153/255, green: 153/255, blue: 153/255),
        Color(red: 148/255, green: 148/255, blue: 148/255),
        Color(red: 142/255, green: 142/255, blue: 142/255),
        Color(red: 137/255, green: 137/255, blue: 137/255),
        Color(red: 132/255, green: 132/255, blue: 132/255),
        Color(red: 127/255, green: 127/255, blue: 127/255),
        Color(red: 121/255, green: 121/255, blue: 121/255),
        Color(red: 116/255, green: 116/255, blue: 116/255),
        Color(red: 111/255, green: 111/255, blue: 111/255),
        Color(red: 106/255, green: 106/255, blue: 106/255),
        Color(red: 101/255, green: 101/255, blue: 101/255),
        Color(red: 96/255, green: 96/255, blue: 96/255),
        Color(red: 91/255, green: 91/255, blue: 91/255),
        Color(red: 86/255, green: 86/255, blue: 86/255),
        Color(red: 82/255, green: 82/255, blue: 82/255),
        Color(red: 77/255, green: 77/255, blue: 77/255),
        Color(red: 72/255, green: 72/255, blue: 72/255),
        Color(red: 67/255, green: 67/255, blue: 67/255),
        Color(red: 63/255, green: 63/255, blue: 63/255),
        Color(red: 58/255, green: 58/255, blue: 58/255),
        Color(red: 53/255, green: 53/255, blue: 53/255),
        Color(red: 47/255, green: 47/255, blue: 47/255),
        Color(red: 43/255, green: 43/255, blue: 43/255),
        Color(red: 39/255, green: 39/255, blue: 39/255),
        Color(red: 34/255, green: 34/255, blue: 34/255),
        Color(red: 32/255, green: 32/255, blue: 32/255),
        Color(red: 32/255, green: 32/255, blue: 32/255),
        Color(red: 28/255, green: 28/255, blue: 28/255),
        Color(red: 24/255, green: 24/255, blue: 24/255),
        Color(red: 20/255, green: 20/255, blue: 20/255),
        Color(red: 14/255, green: 14/255, blue: 14/255),
        Color(red: 7/255, green: 7/255, blue: 7/255),
        Color(red: 0, green: 0, blue: 0),
    ]
    
    private var queuedColors: [Color]
    
    var currentColor: Color? {
        return self.queuedColors.last
    }
    
    func consume() {
        self.queuedColors.removeLast()
        if self.queuedColors.isEmpty {
            self.queuedColors = self.generatedColors.shuffled()
        }
    }
    
    init() {
        self.queuedColors = self.generatedColors.shuffled()
    }
}
