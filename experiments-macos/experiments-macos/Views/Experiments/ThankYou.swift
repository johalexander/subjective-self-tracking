//
//  ThankYou.swift
//  Subjective Self Tracking
//
//  Alexander Johansson 2024
//

import SwiftUI

struct ThankYou: View {
    @ObservedObject var vm: ExperimentViewModel

    var body: some View {
        VStack {
            Text("Thank you for participating! 🎉")
                .font(.largeTitle)
                .padding(.top)

            Text("Your data has been saved.")
                .font(.body)
                .padding(.top, 10)
            
            Text("Your participant number is **\(vm.participantNumber)**")
                .font(.body)
                .padding(.top, 10)
            
            Link("Please complete the following survey", destination: URL(string: "https://forms.gle/7dVZtCupby3Ag5rk8")!)
                .padding(.top, 1)
            
            Text("Your contribution is much appreciated ❤️")
                .font(.body)
                .padding(.top, 10)
            
            Text("Go grab an ice cream on me 🍦")
                .font(.body)
                .padding(.top, 1)
        }
        .padding()
        .onAppear {
            vm.saveData()
        }
        .navigationTitle("✨ Thank you!")
    }
}

#Preview {
    ThankYou(vm: ExperimentViewModel(participantNumber: 1))
}
