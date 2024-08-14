//
//  ExperimentGestureRollNumberView.swift
//  Subjective Self Tracking
//
//  Alexander Johansson 2024
//

import SwiftUI

struct ExperimentGestureRollNumberView: View {
    @ObservedObject var experiments: ExperimentViewModel
    @ObservedObject var data: DataViewModel

    @State var stimuliCount: Int = 1
    @State var maxStimuliCount: Int = 20
    
    @State var trialStimuliCount: Int = 1
    @State var maxTrialStimuliCount: Int = 3
    
    @State var inTrial: Bool = true
    
    @State private var selectedNumber: String = DataViewModel.sharedSingleton.getTrialNumber()
    
    let experimentType: ExperimentType = .gestureRollNumber
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
                        
                        Text("Adjust rotation of your forearm to match the number as closely as possible")
                            .font(.title3)
                            .padding(.bottom, 2)
                        
                        AnimatedImage("side_number")
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
                        Text("Adjust rotation of your forearm to match the number as closely as possible")
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
                    Button("Skip") {
                        submitInput()
                    }
                    .hidden()
                    .keyboardShortcut("s")
                    Button("Next Experiment") {
                        experiments.nextExperiment()
                    }
                    .hidden()
                    .keyboardShortcut("d")
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
                        data.consumeNumber()
                        selectedNumber = data.getNumber()
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
        let stimuli = Stimuli(id: String(stimuliCount), value: 0.0, truth: Double(selectedNumber) ?? 0.0, inputType: .device, sensorReading: data.associatedReading)
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
            withAnimation(.easeIn) {
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
}

#Preview {
    ExperimentGestureRollNumberView(experiments: ExperimentViewModel(participantNumber: 1), data: DataViewModel())
}
