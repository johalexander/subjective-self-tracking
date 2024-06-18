//
//  Experiments.swift
//  experiments-macos
//
//  Created by Alexander Johansson on 18/05/2024.
//

import Foundation
import SwiftUI

struct ExperimentView: View {
    @ObservedObject var experiments: ExperimentViewModel
    @ObservedObject var data: DataViewModel
    
    @State var participantNumber: Int = 0
    @State var age: String = ""
    @State var genderIdentity: Gender = Gender.undisclosed

    var body: some View {
        VStack {
            if experiments.currentExperimentIndex < experiments.experimentOrder.count {
                switch experiments.experimentOrder[experiments.currentExperimentIndex] {
                case .sliderGreyscale:
                    ExperimentSliderGreyscaleView(experiments: experiments, data: data)
                case .sliderNumber:
                    ExperimentSliderNumberView(experiments: experiments, data: data)
                case .gesturePitchGreyscale:
                    ExperimentGesturePitchGreyscaleView(experiments: experiments, data: data)
                case .gesturePitchNumber:
                    ExperimentGesturePitchNumberView(experiments: experiments, data: data)
                case .gestureRollGreyscale:
                    ExperimentGestureRollGreyscaleView(experiments: experiments, data: data)
                case .gestureRollNumber:
                    ExperimentGestureRollNumberView(experiments: experiments, data: data)
                }
            } else {
                ThankYou(vm: experiments)
            }
        }
        .navigationTitle(navigationTitle)
        .navigationBarBackButtonHidden()
        .animation(.bouncy, value: experiments.currentExperimentIndex)
        .onAppear {
            experiments.setup(participantNumber: participantNumber, age: age, genderIdentity: genderIdentity.rawValue)
            saveParticipantCount(experiments.participantNumber)
            data.shuffleStimuli()
        }
    }
    
    var navigationTitle: String {
        guard experiments.currentExperimentIndex < experiments.experimentOrder.count else {
            return "✨ Thank you!"
        }
        return "Experiment " + "\(experiments.currentExperimentIndex + 1): " + experiments.experimentOrder[experiments.currentExperimentIndex].description
    }
}

struct Experiments: View {
    @EnvironmentObject var vm: DataViewModel
    @EnvironmentObject var evm: ExperimentViewModel
    
    @State private var participantNumber: Int = 0
    @State private var age: String = ""
    @State private var genderIdentity: Gender = Gender.undisclosed
    
    @State private var enabled = false
    @State private var shouldNavigate = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Welcome to the Experiments 🧑‍🔬")
                        .font(.largeTitle)
                        .padding(.top)
                    
                    VStack(alignment: .leading) {
                        Text("During the experiments you will be asked to assess greyness of an image and position of a number on a visual scale using a slider. You will also be asked to assess greyness of an image and position of a number on a physical scale using the prototype.")
                            .font(.body)
                        Text("For each experiment, you will be asked to indicate a response to **20 different stimuli**.")
                            .font(.body)
                            .padding(.top, 1)
                        Text("Prior to each experiment, there are **3 trial attempts** for the task context. They are not a part of the experiment.")
                            .font(.body)
                            .padding(.top, 1)
                        Text("The approximate time to complete all experiments is **15 minutes**.")
                            .font(.body)
                            .padding(.top, 1)
                    }
                    .padding(.vertical)
                    
                    Text("The order of the experiments is determined by a Latin square design to minimize order effects.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Divider().padding(.vertical)
                    
                    Group {
                        HStack {
                            Text("Please enter your details:")
                                .font(.body)
                            
                            Spacer()
                            
                            Label("Hover for data collection purpose", systemImage: "info.circle")
                                .foregroundColor(.secondary)
                                .help("Why is this data collected?\n\nThis data is collected for statistical and bias purposes.")
                        }
                        
                        TextField("Age (required)", text: $age)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .help("Please enter your age")
                        
                        Picker("Gender identity", selection: $genderIdentity) {
                            Text("Male").tag(Gender.male)
                            Text("Female").tag(Gender.female)
                            Text("Other").tag(Gender.other)
                            Text("Prefer to not disclose").tag(Gender.undisclosed)
                        }
                    }
                    
                    Divider().padding(.vertical)
                    
                    VStack(alignment: .leading, spacing: 7) {
                        Text("Before starting please make sure that the device is fastened to your wrist.")
                            .font(.headline)
                        
                        Text("Make sure to only click once per stimuli. You may be asked to repeat the input for a stimuli.")
                            .font(.headline)
                        
                        Text("Please be gentle with the device. Avoid hard presses.")
                            .font(.headline)
                            .padding(.bottom)
                        
                        if !enabled {
                            Text("Click the device button to unlock the experiments.")
                                .font(.subheadline)
                                .padding(.bottom)
                        }
                    }
                    .animation(.easeIn, value: enabled)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        if !enabled {
                            if vm.receivedData.successful {
                                if vm.receivedData.sufficientCalibration {
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
                                        Text("Please repeat the input (low calibration)")
                                    }
                                }
                            } else {
                                HStack(spacing: 10) {
                                    ProgressView()
                                    Text("Awaiting input from device...")
                                }
                            }
                        }
                        
                        NavigationLink(destination: ExperimentView(experiments: evm, data: vm, participantNumber: participantNumber, age: age, genderIdentity: genderIdentity)) {
                            Text("Start experiments")
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(!enabled || age.isEmpty)
                        .onChange(of: vm.receivedData, { oldValue, newValue in
                            if !oldValue.successful && newValue.successful && newValue.sufficientCalibration {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                                    enabled = true
                                }
                            }
                        })
                        
                        Button("Start Experiments") {
                            vm.showForceExpStartAlert = true
                        }
                        .hidden()
                        .keyboardShortcut("f")
                    }
                    .animation(.easeIn, value: enabled)
                    .animation(.easeIn, value: age)
                }
                .padding()
            }
        }
        .onAppear {
            participantNumber = readParticipantCount() + 1
        }
        .navigationTitle("🧪 Experiments")
        .navigationDestination(isPresented: $shouldNavigate, destination: {
            ExperimentView(experiments: evm, data: vm, participantNumber: participantNumber, age: age, genderIdentity: genderIdentity)
        })
        .alert("Force experiment start", isPresented: $vm.showForceExpStartAlert) {
            TextField("Participant id (current: \(readParticipantCount()))", text: $vm.newParticipantCount)
            TextField("Starting index", text: $vm.forceStartIndex)
            Button("Start", action: {
                participantNumber = Int(vm.newParticipantCount) ?? (readParticipantCount() + 1)
                vm.updateParticipantCount()
                evm.participantNumber = participantNumber
                evm.startAtExperiment(index: Int(vm.forceStartIndex) ?? 0)
                shouldNavigate = true
                vm.showAlert = false
            })
            Button("Cancel", role: .cancel) {}
        }
    }
}

#Preview {
    Experiments()
        .environmentObject(DataViewModel())
        .environmentObject(ExperimentViewModel(participantNumber: readParticipantCount() + 1))
}
