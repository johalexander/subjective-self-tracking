import SwiftUI

struct ExperimentGesturePitchGreyscaleView: View {
    @ObservedObject var experiments: ExperimentViewModel
    @ObservedObject var data: DataViewModel

    @State var stimuliCount: Int = 1
    @State var maxStimuliCount: Int = 20
    
    @State var trialStimuliCount: Int = 1
    @State var maxTrialStimuliCount: Int = 3
    
    @State var inTrial: Bool = true
    
    @State private var transitionOpacity: Double = 1.0
    
    @State private var selectedColor: Color = DataViewModel.sharedSingleton.getTrialColor()
    
    let experimentType: ExperimentType = .gesturePitchGreyscale
    @State var successfulStimuli: [Stimuli] = []
    @State var failedStimuli: [Stimuli] = []
    @State var startedDate: Date = Date.now
    @State var endedDate: Date = Date.now
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if inTrial {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Task context")
                            .font(.title)
                        
                        Text("Adjust positioning of your arm to match the color as closely as possible")
                            .font(.title3)
                            .padding(.bottom, 2)
                        
                        AnimatedImage("front_black_white")
                            .frame(width: 450, height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(radius: 10)
                    }
                    .padding()
                    
                    Divider()
                }
                
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
                .animation(.easeIn, value: selectedColor)
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                
                Divider()
                
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading) {
                        Text("Adjust positioning of your arm to match the color as closely as possible")
                            .font(.title3)
                            .padding(.bottom, 2)
                        
                        Text("Click the device button to indicate a response")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                    
                    ZStack {
                        if data.receivedData.successful {
                            if data.receivedData.sufficientCalibration {
                                HStack(spacing: 10) {
                                    Image(systemName: "checkmark.circle")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.green)
                                    Text("Input received!")
                                }
                            } else {
                                HStack(spacing: 10) {
                                    Image(systemName: "exclamationmark.triangle")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.yellow)
                                    Text("Please repeat the input for this stimuli (low calibration)")
                                }
                            }
                        } else {
                            HStack(spacing: 10) {
                                ProgressView()
                                Text("Awaiting input from device...")
                            }
                        }
                    }
                    .animation(.easeIn, value: data.receivedData.successful)
                }
                .padding()
            }
            .padding()
        }
        .onAppear {
            startedDate = Date.now
            consume()
        }
        .onChange(of: stimuliCount, { oldValue, newValue in
            if newValue > maxStimuliCount {
                DispatchQueue.main.async {
                    withAnimation(.easeIn) {
                        storeExperimentData()
                        experiments.nextExperiment()
                    }
                }
            }
        })
        .onChange(of: trialStimuliCount, { oldValue, newValue in
            if newValue > maxTrialStimuliCount {
                DispatchQueue.main.async {
                    withAnimation(.easeIn) {
                        inTrial = false
                        data.consumeColor()
                        selectedColor = data.getColor()
                    }
                }
            }
        })
        .onChange(of: data.receivedData, { oldValue, newValue in
            if oldValue.successful && oldValue.sufficientCalibration && !newValue.successful {
                submitInput()
            }
        })
    }
    
    func storeExperimentData() {
        endedDate = Date.now
        let experiment = Experiment(id: String(experiments.currentExperimentIndex + 1), experimentType: experimentType.type, successfulStimuli: successfulStimuli, failedStimuli: failedStimuli, startedDate: startedDate, endedDate: endedDate)
        experiments.addExperimentData(experiment)
    }
    
    func addStimuli(successful: Bool) {
        let stimuli = Stimuli(id: String(stimuliCount), value: 0.0, truth: Double(data.getColorId()), inputType: .device, sensorReading: data.associatedReading)
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
        DispatchQueue.main.async {
            withAnimation(.easeIn, {
                transitionOpacity = 0.0
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
}

#Preview {
    ExperimentGesturePitchGreyscaleView(experiments: ExperimentViewModel(participantNumber: 1), data: DataViewModel())
}
