//
//  DataModelManager.swift
//  Subjective Self Tracking
//
//  Created by Alexander Johansson on 19/05/2024.
//

import Foundation

class DataModelManager: ObservableObject {
    @Published var receivedData: Bool = false
    
    @Published var navItems: [Item] = [
        Item(title: "Learn", imageName: "💪🏻"),
        Item(title: "Experiments", imageName: "🧪"),
        Item(title: "Settings", imageName: "⚙️"),
    ]
    
    static let shared = DataModelManager()

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
}
