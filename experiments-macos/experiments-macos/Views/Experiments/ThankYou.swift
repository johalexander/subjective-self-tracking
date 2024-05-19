import SwiftUI

struct ThankYou: View {
    @ObservedObject var vm: ExperimentViewModel

    var body: some View {
        VStack {
            Text("Thank You! 🎉")
                .font(.largeTitle)
                .padding(.top)

            Text("Thank you for participating in the experiments.")
                .font(.headline)
                .padding(.top, 20)

            Text("Your data has been saved.")
                .font(.body)
                .padding(.top, 10)
            
            Text("Your contribution is much appreciated. ❤️")
                .font(.body)
                .padding(.top, 10)
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
