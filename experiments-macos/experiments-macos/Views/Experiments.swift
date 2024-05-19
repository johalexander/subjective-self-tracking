//
//  Experiments.swift
//  experiments-macos
//
//  Created by Alexander Johansson on 18/05/2024.
//

import Foundation
import SwiftUI

struct Experiments: View {
    @EnvironmentObject var vm: DataViewModel
    
    @State private var age: String = ""
    @State private var genderIdentity: Gender = Gender.undisclosed
    @State private var email: String = ""
    @State private var sendQuestionnaire: Bool = false
    
    @State private var enabled = false
    
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.allowsFloats = false
        formatter.minimum = 0
        formatter.maximum = 100
        return formatter
    }

    let experiments = [
        "Experiment 1: Slider - Greyscale",
        "Experiment 2: Slider - Number",
        "Experiment 3: Gesture: Pitch - Greyscale",
        "Experiment 4: Gesture: Pitch - Number",
        "Experiment 5: Gesture: Roll - Greyscale",
        "Experiment 6: Gesture: Roll - Number"
    ]
    
    enum Gender: String, CaseIterable, Identifiable {
        case male
        case female
        case nonbinary
        case undisclosed
        
        var id: Self { self }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Welcome to the Experiments")
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
                    
                    Text("If you have observed any other participants, you may have noticed that the order of experiments shift. The order of the experiments is determined by a Latin square design to minimize order effects.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.top, 2)

                    Divider().padding(.vertical)
                    
                    Group {
                        Text("Please enter your details:")
                            .font(.body)
                        
                        TextField("Age", value: $age, formatter: numberFormatter)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .help("Please enter your age")
                        
                        Picker("Gender identity", selection: $genderIdentity) {
                            Text("Male").tag(Gender.male)
                            Text("Female").tag(Gender.female)
                            Text("Non-binary").tag(Gender.nonbinary)
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
                    
                    Text("Before starting please make sure that the device is powered (lights on).")
                        .font(.headline)
                        .padding(.bottom)
                    
                    Text("Make sure to only click once per stimuli.")
                        .font(.headline)
                        .padding(.bottom)
                    
                    Text("Please be gentle with the device.")
                        .font(.headline)
                        .padding(.bottom)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        if !enabled {
                            HStack(spacing: 10) {
                                ProgressView()
                                Text("Awaiting input to allow proceeding...")
                            }
                        }
                        
                        Button(action: {
                            
                        }) {
                            Text("Start experiments")
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(!enabled)
                        .onChange(of: vm.receivedData, { oldValue, newValue in
                            if !oldValue && newValue {
                                enableStart()
                            }
                        })
                    }
                    .animation(.easeIn, value: enabled)
                }
                .padding()
            }
        }
        .navigationTitle("🧪 Experiments")
    }
    
    func enableStart() {
        enabled = true
    }
}

#Preview {
    Experiments()
        .environmentObject(DataViewModel())
}
