import SwiftUI

class ExperimentViewModel: ObservableObject {
    @Published var experiments: [Experiment] = []
    @Published var currentExperimentIndex = 0
    @Published var experimentOrder: [ExperimentType] = []
    @Published var id: String = ""
    @Published var age: String = ""
    @Published var genderIdentity: String = ""
    @Published var startedDate: Date = Date.now
    @Published var endedDate: Date = Date.now
    
    private var latinSquare: [[Int]]
    private var expOrder: [ExperimentType]
    var participantNumber: Int

    init(participantNumber: Int) {
        self.latinSquare = generateLatinSquare(size: ExperimentType.allCases.count)
        self.participantNumber = participantNumber
        self.expOrder = self.latinSquare[participantNumber % self.latinSquare.count].compactMap {
            ExperimentType(rawValue: $0)
        }
        DispatchQueue.main.async {
            self.experimentOrder = self.expOrder
        }
    }

    func addExperimentData(_ experiment: Experiment) {
        DispatchQueue.main.async {
            self.experiments.append(experiment)
            self.saveData()
        }
    }

    func nextExperiment() {
        DispatchQueue.main.async {
            self.currentExperimentIndex = self.currentExperimentIndex + 1
        }
    }

    func reset() {
        DispatchQueue.main.async {
            self.experiments.removeAll()
            self.currentExperimentIndex = 0
            self.experimentOrder = self.latinSquare[self.participantNumber % self.latinSquare.count].compactMap {
                ExperimentType(rawValue: $0)
            }
        }
    }

    func saveData() {
        DispatchQueue.main.async {
            self.endedDate = Date.now
            let data = Participant(id: self.id, age: self.age, genderIdentity: self.genderIdentity, completedExperiments: self.experiments)
            
            let encoder = JSONEncoder()
            if let encodedData = try? encoder.encode(data) {
                let filename = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("experiment_data_\(self.participantNumber).json")
                try? encodedData.write(to: filename)
                print("Data saved to \(filename)")
            }
        }
    }
    
    func setup(participantNumber: Int, age: String, genderIdentity: String) {
        DispatchQueue.main.async {
            self.id = String(participantNumber)
            self.age = age
            self.genderIdentity = genderIdentity
            self.startedDate = Date.now
        }
        
        self.latinSquare = generateLatinSquare(size: ExperimentType.allCases.count)
        self.participantNumber = participantNumber
        self.expOrder = self.latinSquare[participantNumber % self.latinSquare.count].compactMap {
            ExperimentType(rawValue: $0)
        }
        DispatchQueue.main.async {
            self.experimentOrder = self.expOrder
        }
    }
}

