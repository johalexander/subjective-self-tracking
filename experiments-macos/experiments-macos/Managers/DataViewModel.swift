//
//  DataModelManager.swift
//  Subjective Self Tracking
//
//  Created by Alexander Johansson on 19/05/2024.
//

import Foundation
import SwiftUI

class DataViewModel: ObservableObject {
    @Published var isRunning: Bool = false
    @Published var ipAddress: String = "Unknown"
    @Published var port: Int = 8080
    
    @Published var receivedData: Bool = false
    
    @Published var navItems: [Item] = [
        Item(title: "Learn", imageName: "💪🏻"),
        Item(title: "Experiments", imageName: "🧪"),
        Item(title: "Settings", imageName: "⚙️"),
    ]
    
    @Published var participants = [
        Participant(age: 20, genderIdentity: "Male", completedExperiments: []),
        Participant(age: 25, genderIdentity: "Male", completedExperiments: []),
        Participant(age: 32, genderIdentity: "Male", completedExperiments: []),
        Participant(age: 24, genderIdentity: "Male", completedExperiments: []),
    ]
    
    private var colorRepository = Greyscales()
    private var numberRepository = Numbers()
    
    static let sharedSingleton = DataViewModel()
    
    func getColor() -> Color {
        return self.colorRepository.currentColor ?? .white
    }
    
    func getNumber() -> String {
        return self.numberRepository.currentNumber
    }

    func markDataReceived() {
        DispatchQueue.main.async {
            self.receivedData = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.resetReceivedData()
        }
    }

    func resetReceivedData() {
        DispatchQueue.main.async {
            self.receivedData = false
        }
    }
    
    func consume() {
        DispatchQueue.main.async {
            self.colorRepository.consume()
            self.numberRepository.consume()
        }
    }
}
