//
//  Practice.swift
//  experiments-macos
//
//  Created by Alexander Johansson on 18/05/2024.
//

import Foundation
import SwiftUI

struct Practice: View {
    @EnvironmentObject var vm: DataViewModel
    
    @State private var input: Double = 0
    
    @State private var selectedStimuli = "Greyscale"
    var stimuli = ["Greyscale", "Number"]
    
    @State private var selectedMode = "Slider"
    var modes = ["Slider", "Device"]
    
    @State private var selectedMovement = "Pitch"
    var movements = ["Pitch", "Roll"]
    
    @State private var selectedColor: Color = DataViewModel.sharedSingleton.getColor()
    @State private var selectedNumber: String = DataViewModel.sharedSingleton.getNumber()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Picker(selection: $selectedStimuli, label: Text("Practice stimuli")) {
                    ForEach(stimuli, id: \.self) {
                        Text($0)
                    }
                }
                .onChange(of: selectedStimuli, {
                    input = 0
                })
                .pickerStyle(.segmented)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                Picker(selection: $selectedMode, label: Text("Practice mode")) {
                    ForEach(modes, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                
                ZStack {
                    if selectedStimuli == "Greyscale" {
                        Image("Static")
                            .resizable()
                            .frame(height: 240)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(selectedColor)
                            .frame(width: 150, height: 150)
                    } else {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.white)
                            .frame(height: 240)
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(red: 44/255, green:44/255, blue:42/255))
                            .frame(width: 150, height: 150)
                        
                        Text(selectedNumber)
                            .font(.system(size: 60))
                    }
                }
                .animation(.easeIn, value: selectedStimuli)
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                
                Divider()
                
                ZStack {
                    if selectedMode == "Slider" {
                        VStack(alignment: .leading, spacing: 20) {
                            VStack(alignment: .leading) {
                                Text("Visual Analogue Scale (VAS)")
                                    .font(.headline)
                                
                                if selectedStimuli == "Greyscale" {
                                    Text("Adjust the slider to match the color as closely as possible")
                                } else {
                                    Text("Adjust the slider to match the number as closely as possible")
                                }
                                
                                Text("Click the \"Next\" button to indicate a response")
                            }
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            
                            if selectedStimuli == "Greyscale" {
                                Slider(value: $input, in: 0...49) {
                                } minimumValueLabel: {
                                    Text("White")
                                } maximumValueLabel: {
                                    Text("Black")
                                }
                            } else {
                                Slider(value: $input, in: 0...100) {
                                } minimumValueLabel: {
                                    Text("0")
                                } maximumValueLabel: {
                                    Text("100")
                                }
                            }
                            
                            HStack(alignment: .center) {
                                if selectedStimuli == "Greyscale" {
                                    DisclosureGroup("Possible greyscale values") {
                                        SquareImage(image: Image("GreyscaleValues").resizable())
                                            .frame(height: 130)
                                            .padding()
                                    }
                                }
                                Spacer()
                                Button("Next") {
                                    consume()
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                        .padding()
                        .animation(.easeIn, value: selectedStimuli)
                    } else {
                        VStack(alignment: .leading, spacing: 20) {
                            Picker(selection: $selectedMovement, label: Text("Movement")) {
                                ForEach(movements, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(.segmented)
                            
                            VStack(alignment: .leading) {
                                Text("Physical Analogue Scale (PAS)")
                                    .font(.headline)
                                
                                if selectedMovement == "Pitch" {
                                    if selectedStimuli == "Greyscale" {
                                        Text("Adjust positioning of your arm to match the color as closely as possible")
                                    } else {
                                        Text("Adjust positioning of your arm to match the number as closely as possible")
                                    }
                                
                                    Text("Click the device button to indicate a response")
                                } else {
                                    if selectedStimuli == "Greyscale" {
                                        Text("Adjust rotation of your forearm to match the color as closely as possible")
                                    } else {
                                        Text("Adjust rotation of your forearm to match the number as closely as possible")
                                    }
                                    
                                    Text("Click the device button to indicate a response")
                                }
                            }
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            
                            ZStack {
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
                            .animation(.easeIn, value: vm.receivedData)
                            
                            DisclosureGroup("Reference scales") {
                                SquareImage(image: Image("GreyscaleValues").resizable())
                                    .frame(height: 130)
                                    .padding()
                            }
                        }
                        .padding()
                        .animation(.easeIn, value: selectedStimuli)
                        .animation(.easeIn, value: selectedMovement)
                    }
                }
                .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/, value: selectedMode)
            }
            .padding()
            .onChange(of: vm.receivedData, { oldValue, newValue in
                if oldValue && !newValue && vm.sufficientCalibration {
                    consume()
                }
            })
        }
        .navigationTitle("💪🏻 Practice")
    }
    
    func consume() {
        withAnimation(.easeIn) {
            vm.consume()
            selectedColor = vm.getColor()
            selectedNumber = vm.getNumber()
        }
    }
}

#Preview {
    Practice()
        .environmentObject(DataViewModel())
}
