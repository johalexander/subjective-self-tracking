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
    
    @Published var receivedData: DataContainer = DataContainer(successful: false, sufficientCalibration: false)
    @Published var associatedReading: SensorReading = SensorReading(timestamp: 0, duration: 0, stability: "", activity: "", activity_confidence: 0, calibration_status: 0, w: 0, x: 0, y: 0, z: 0)
    
    @Published var navItems: [Item] = [
        Item(title: "Learn", imageName: "💪🏻"),
        Item(title: "Experiments", imageName: "🧪"),
        Item(title: "Settings", imageName: "⚙️"),
    ]
    
    @Published var participants: [Participant] = []
    
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var showSetCountAlert = false
    @Published var newParticipantCount: String = ""
    @Published var participantCount = readParticipantCount()
    
    private var colorRepository = Greyscales()
    private var numberRepository = Numbers()
    
    static let sharedSingleton = DataViewModel()
    
    private let dataDirectory: URL
    
    init() {
        dataDirectory = FileManager.default.homeDirectoryForCurrentUser
        loadParticipantData()
    }
    
    func loadParticipantData() {
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: dataDirectory, includingPropertiesForKeys: nil)
                .filter { $0.pathExtension == "json" }
            let decoder = JSONDecoder()
            participants = try fileURLs.compactMap { url in
                let data = try Data(contentsOf: url)
                return try decoder.decode(Participant.self, from: data)
            }
        } catch {
            print("Error loading participant data: \(error)")
        }
    }
    
    func exportParticipantData() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(participants)
            saveFile(data: data)
        } catch {
            print("Error encoding participant data: \(error)")
        }
    }
    
    func saveFile(data: Data) {
        let savePanel = NSSavePanel()
        savePanel.title = "Save Combined Participant Data"
        savePanel.allowedContentTypes = [.json]
        savePanel.nameFieldStringValue = "combined_participant_data.json"
        
        savePanel.begin { response in
            if response == .OK, let url = savePanel.url {
                do {
                    try data.write(to: url)
                    print("File saved successfully: \(url)")
                } catch {
                    print("Error saving file: \(error)")
                }
            }
        }
    }
    
    func deleteAllData() {
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: dataDirectory, includingPropertiesForKeys: nil)
                .filter { $0.pathExtension == "json" }
            for url in fileURLs {
                try FileManager.default.removeItem(at: url)
            }
            let countFileURL = dataDirectory.appendingPathComponent("participant_count.txt")
            if FileManager.default.fileExists(atPath: countFileURL.path) {
                try FileManager.default.removeItem(at: countFileURL)
            }
            participants.removeAll()
            alertMessage = "All data deleted successfully."
        } catch {
            print("Error deleting data: \(error)")
            alertMessage = "Error deleting data: \(error.localizedDescription)"
        }
        alertTitle = "Data Deletion"
        showAlert = true
        participantCount = readParticipantCount()
    }
    
    func updateParticipantCount() {
        if let count = Int(newParticipantCount) {
            participantCount = count
            saveParticipantCount(count)
            alertMessage = "Participant count updated successfully."
        } else {
            alertMessage = "Invalid participant count."
        }
        alertTitle = "Participant Count"
        showAlert = true
    }
    
    func getColor() -> Color {
        return self.colorRepository.currentColor ?? .white
    }
    
    func getNumber() -> String {
        return self.numberRepository.currentNumber
    }

    func markDataReceived(data: SensorReading, sufficientCalibration: Bool) {
        DispatchQueue.main.async {
            self.receivedData = DataContainer(successful: true, sufficientCalibration: sufficientCalibration)
            self.associatedReading = data
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.resetReceivedData()
        }
    }

    func resetReceivedData() {
        DispatchQueue.main.async {
            self.receivedData = DataContainer(successful: false, sufficientCalibration: false)
        }
    }
    
    func consume() {
        DispatchQueue.main.async {
            self.colorRepository.consume()
            self.numberRepository.consume()
        }
    }
}

struct DataContainer: Equatable {
    var successful: Bool
    var sufficientCalibration: Bool
}
