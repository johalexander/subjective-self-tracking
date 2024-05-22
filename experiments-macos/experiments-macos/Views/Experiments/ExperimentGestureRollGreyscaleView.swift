import SwiftUI


struct ExperimentGestureRollGreyscaleView: View {
    @ObservedObject var experiments: ExperimentViewModel
    @ObservedObject var data: DataViewModel

    @State var stimuliCount: Int = 1
    @State var maxStimuliCount: Int = 20
    
    let experimentType: ExperimentType = .gestureRollGreyscale
    @State var successfulStimuli: [Stimuli] = []
    @State var failedStimuli: [Stimuli] = []
    @State var startedDate: Date = Date.now
    @State var endedDate: Date = Date.now
    
    var body: some View {
        VStack {
            Text("Stimuli \(stimuliCount) out of \(maxStimuliCount)")
                .font(.largeTitle)
                .padding()
            
            
        }
        .onAppear {
            startedDate = Date.now
        }
        .onChange(of: stimuliCount, { oldValue, newValue in
            if newValue > maxStimuliCount {
                storeExperimentData()
                experiments.nextExperiment()
            }
        })
        .navigationTitle("Experiment " + "\(experiments.currentExperimentIndex + 1): " + ExperimentType.gestureRollGreyscale.description)
    }
    
    func storeExperimentData() {
        endedDate = Date.now
        let experiment = Experiment(id: String(experiments.currentExperimentIndex + 1), experimentType: experimentType.type, successfulStimuli: successfulStimuli, failedStimuli: failedStimuli, startedDate: startedDate, endedDate: endedDate)
        experiments.addExperimentData(experiment)
    }
}

#Preview {
    ExperimentGestureRollGreyscaleView(experiments: ExperimentViewModel(participantNumber: 1), data: DataViewModel())
}
