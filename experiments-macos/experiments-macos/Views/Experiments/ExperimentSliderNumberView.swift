import SwiftUI


struct ExperimentSliderNumberView: View {
    @ObservedObject var experiments: ExperimentViewModel
    @ObservedObject var data: DataViewModel

    @State private var input: Double = 0.0
    
    @State var stimuliCount: Int = 1
    @State var maxStimuliCount: Int = 20
    
    @State var trialStimuliCount: Int = 1
    @State var maxTrialStimuliCount: Int = 5
    
    @State var inTrial: Bool = true
    
    @State private var selectedNumber: String = DataViewModel.sharedSingleton.getTrialNumber()
    
    let experimentType: ExperimentType = .sliderNumber
    @State var successfulStimuli: [Stimuli] = []
    @State var failedStimuli: [Stimuli] = []
    @State var startedDate: Date = Date.now
    @State var endedDate: Date = Date.now
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    if inTrial {
                        VStack {
                            Text("Trial stimuli **\(trialStimuliCount)** out of **\(maxTrialStimuliCount)**")
                                .font(.largeTitle)
                                .padding()
                            Text("Use these trial attempts to familiarise yourself with the input type")
                                .font(.body)
                                .foregroundStyle(.secondary)
                                .padding(.bottom, 5)
                        }
                    } else {
                        Text("Stimuli **\(stimuliCount)** out of **\(maxStimuliCount)**")
                            .font(.largeTitle)
                            .padding()
                    }
                    Spacer()
                }
                .animation(.easeIn, value: stimuliCount)
                .animation(.easeIn, value: trialStimuliCount)
                .animation(.easeIn, value: inTrial)
                
                Divider()
                
                if inTrial {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Task context")
                            .font(.title)
                        
                        Text("Adjust the slider to match the number as closely as possible")
                            .font(.title3)
                            .padding(.bottom, 2)
                        
                        AnimatedImage("slider_number")
                            .frame(width: 450, height: 45)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(radius: 10)
                    }
                    .padding()
                    
                    Divider()
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white)
                        .frame(height: 600)
                        .shadow(radius: 7)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 44/255, green:44/255, blue:42/255))
                        .frame(width: 300, height: 300)
                        .shadow(radius: 10)
                    
                    Text(selectedNumber)
                        .font(.system(size: 100))
                }
                .animation(.easeIn, value: selectedNumber)
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                
                Divider()
                
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading) {
                        Text("Adjust the slider to match the number as closely as possible")
                            .font(.title3)
                            .padding(.bottom, 2)
                        
                        Text("Click the **\"Next\"** button to indicate a response")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                    
                    Slider(value: $input, in: 0...100) {
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("100")
                    }
                    
                    HStack {
                        Spacer()
                        Button("Next") {
                            submitInput()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding()
            }
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
        .onChange(of: trialStimuliCount, { oldValue, newValue in
            if newValue > maxTrialStimuliCount {
                inTrial = false
                selectedNumber = data.getNumber()
            }
        })
        .navigationTitle("Experiment " + "\(experiments.currentExperimentIndex + 1): " + ExperimentType.sliderNumber.description)
    }
    
    func storeExperimentData() {
        endedDate = Date.now
        let experiment = Experiment(id: String(experiments.currentExperimentIndex + 1), experimentType: experimentType.type, successfulStimuli: successfulStimuli, failedStimuli: failedStimuli, startedDate: startedDate, endedDate: endedDate)
        experiments.addExperimentData(experiment)
    }
    
    func addStimuli(successful: Bool) {
        let stimuli = Stimuli(id: String(stimuliCount), value: input, inputType: .slider, sensorReading: data.associatedReading)
        if successful {
            successfulStimuli.append(stimuli)
        } else {
            failedStimuli.append(stimuli)
        }
    }
    
    func submitInput() {
        if inTrial {
            trialStimuliCount += 1
        } else {
            addStimuli(successful: true)
            stimuliCount += 1
        }
        consume()
    }
    
    func consume() {
        withAnimation(.easeIn) {
            input = 0
            if inTrial {
                data.consumeTrialNumber()
                selectedNumber = data.getTrialNumber()
            } else {
                data.consumeNumber()
                selectedNumber = data.getNumber()
            }
        }
    }
}

#Preview {
    ExperimentSliderNumberView(experiments: ExperimentViewModel(participantNumber: 1), data: DataViewModel())
}
