//
//  Experiments.swift
//  experiments-macos
//
//  Created by Alexander Johansson on 18/05/2024.
//

import Foundation
import SwiftUI

struct ExperimentView: View {
    @ObservedObject var vm: ExperimentViewModel

    var body: some View {
        VStack {
            if vm.currentExperimentIndex < vm.experimentOrder.count {
                switch vm.experimentOrder[vm.currentExperimentIndex] {
                case .sliderGreyscale:
                    ExperimentSliderGreyscaleView(vm: vm)
                case .sliderNumber:
                    ExperimentSliderNumberView(vm: vm)
                case .gesturePitchGreyscale:
                    ExperimentGesturePitchGreyscaleView(vm: vm)
                case .gesturePitchNumber:
                    ExperimentGesturePitchNumberView(vm: vm)
                case .gestureRollGreyscale:
                    ExperimentGestureRollGreyscaleView(vm: vm)
                case .gestureRollNumber:
                    ExperimentGestureRollNumberView(vm: vm)
                }
            } else {
                ThankYou(vm: vm)
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            saveParticipantCount(vm.participantNumber)
        }
    }
}

struct Experiments: View {
    @EnvironmentObject var vm: DataViewModel
    
    @State private var participantNumber: Int = readParticipantCount() + 1
    @State private var age: String = ""
    @State private var genderIdentity: Gender = Gender.undisclosed
    @State private var email: String = ""
    @State private var sendQuestionnaire: Bool = false
    
    @State private var enabled = false

    let experiments = [
        "Experiment 1: Slider - Greyscale",
        "Experiment 2: Slider - Number",
        "Experiment 3: Gesture: Pitch - Greyscale",
        "Experiment 4: Gesture: Pitch - Number",
        "Experiment 5: Gesture: Roll - Greyscale",
        "Experiment 6: Gesture: Roll - Number"
    ]

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
                        Text("Each experiment runs with a stimuli count of 20. The approximate time to complete all experiments is 6-10 minutes.")
                            .font(.body)
                            .padding(.top, 1)
                    }
                    .padding(.vertical)

                    ForEach(experiments, id: \.self) { experiment in
                        Text(experiment)
                            .font(.body)
                            .padding(.bottom, 2)
                    }
                    
                    Text("The order of the experiments is determined by a Latin square design to minimize order effects.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.top, 2)

                    Divider().padding(.vertical)
                    
                    Group {
                        HStack {
                            Text("Please enter your details:")
                                .font(.body)
                            
                            Spacer()
                            
                            Label("Hover for data collection purpose", systemImage: "info.circle")
                                .foregroundColor(.secondary)
                                .help("Why is this data collected?\n\nThis data is collected for statistical and bias purposes. \n\nEmails may be used to send out a questionnaire to consenting participants. Emails are stored ephemerally.")
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
                        
                        TextField("Email (optional)", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Toggle(isOn: $sendQuestionnaire) {
                            Text("I would like to answer an optional questionnaire")
                        }
                        
                        Text("Emails are omitted from the generated datasets and will not be a part of any appendix.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding(.top, 2)
                    }
                    
                    Divider().padding(.vertical)
                    
                    VStack(alignment: .leading, spacing: 7) {
                        Text("Before starting please make sure that the device is powered (lights on).")
                            .font(.headline)
                        
                        Text("Make sure to only click once per stimuli.")
                            .font(.headline)
                        
                        Text("Please be gentle with the device.")
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
                            if vm.receivedData {
                                if vm.sufficientCalibration {
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
                        
                        NavigationLink(destination: ExperimentView(vm: ExperimentViewModel(participantNumber: participantNumber)
                            .setup(id: String(participantNumber), age: age, genderIdentity: genderIdentity.rawValue, email: email, sendQuestionnaire: sendQuestionnaire))) {
                            Text("Start experiments")
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(!enabled || age.isEmpty)
                        .onChange(of: vm.receivedData, { oldValue, newValue in
                            if !oldValue && newValue && vm.sufficientCalibration {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                                    enabled = true
                                }
                            }
                        })
                    }
                    .animation(.easeIn, value: enabled)
                    .animation(.easeIn, value: age)
                }
                .padding()
            }
        }
        .navigationTitle("🧪 Experiments")
    }
}

#Preview {
    Experiments()
        .environmentObject(DataViewModel())
}
