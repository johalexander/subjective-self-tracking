import SwiftUI

class ExperimentViewModel: ObservableObject {
    @Published var experiments: [Experiment] = []
    @Published var currentExperimentIndex = 0
    @Published var experimentOrder: [ExperimentType]
    @Published var id: String = ""
    @Published var age: String = ""
    @Published var genderIdentity: String = ""
    @Published var startedDate: Date = Date.now
    @Published var endedDate: Date = Date.now

    private let latinSquare: [[Int]]
    let participantNumber: Int

    init(participantNumber: Int) {
        self.latinSquare = generateLatinSquare(size: ExperimentType.allCases.count)
        self.participantNumber = participantNumber
        self.experimentOrder = latinSquare[participantNumber % latinSquare.count].compactMap {
            ExperimentType(rawValue: $0)
        }
    }

    func addExperimentData(_ experiment: Experiment) {
        experiments.append(experiment)
    }

    func nextExperiment() {
        currentExperimentIndex += 1
    }

    func reset() {
        experiments.removeAll()
        currentExperimentIndex = 0
        experimentOrder = latinSquare[participantNumber % latinSquare.count].compactMap {
            ExperimentType(rawValue: $0)
        }
    }

    func saveData() {
        self.endedDate = Date.now
        let data = Participant(id: id, age: age, genderIdentity: genderIdentity, completedExperiments: experiments)

        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(data) {
            let filename = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("experiment_data_\(participantNumber).json")
            try? encodedData.write(to: filename)
            print("Data saved to \(filename)")
        }
    }
}

extension ExperimentViewModel {
    func setup(id: String, age: String, genderIdentity: String) -> ExperimentViewModel {
        self.id = id
        self.age = age
        self.genderIdentity = genderIdentity
        self.startedDate = Date.now
        return self
    }
}

