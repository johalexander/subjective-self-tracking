import SwiftUI


struct ExperimentSliderGreyscaleView: View {
    @ObservedObject var experiments: ExperimentViewModel
    @ObservedObject var data: DataViewModel
    
    @State private var input: Double = 0.0
    
    @State var stimuliCount: Int = 1
    @State var maxStimuliCount: Int = 20
    
    @State var trialStimuliCount: Int = 1
    @State var maxTrialStimuliCount: Int = 5
    
    @State var inTrial: Bool = true
    
    @State private var transitionOpacity: Double = 1.0
    
    @State private var selectedColor: Color = DataViewModel.sharedSingleton.getTrialColor()
    
    let experimentType: ExperimentType = .sliderGreyscale
    @State var successfulStimuli: [Stimuli] = []
    @State var failedStimuli: [Stimuli] = []
    @State var startedDate: Date = Date.now
    @State var endedDate: Date = Date.now
    
    var body: some View {
        ScrollView {
            VStack {
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
                            .padding(.top, 10)
                        
                        SquareImage(image: Image("GreyscaleValues").resizable())
                            .frame(height: 130)
                        
                        Divider()
                    }
                }
                
                ZStack {
                    Image("Static")
                        .resizable()
                        .frame(height: 600)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 7)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(selectedColor)
                        .frame(width: 300, height: 300)
                        .opacity(transitionOpacity)
                        .shadow(radius: 10)
                }
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                
                Divider()
                
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading) {
                        Text("Adjust the slider to match the color as closely as possible")
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
                selectedColor = data.getColor()
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
        withAnimation(.easeIn, {
            input = 0
            if inTrial {
                data.consumeTrialColor()
                selectedColor = data.getTrialColor()
            } else {
                data.consumeColor()
                selectedColor = data.getColor()
            }
        }) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeIn) {
                    transitionOpacity = 1.0
                }
            }
        }
    }
}

#Preview {
    ExperimentSliderGreyscaleView(experiments: ExperimentViewModel(participantNumber: 1), data: DataViewModel())
}
