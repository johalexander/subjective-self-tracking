import SwiftUI


struct ExperimentGesturePitchNumberView: View {
    @ObservedObject var vm: ExperimentViewModel

    var body: some View {
        VStack {
            Text("Experiment " + "\(vm.currentExperimentIndex + 1): " + ExperimentType.gesturePitchNumber.description)
                .font(.largeTitle)
                .padding()

            Button(action: {
                vm.nextExperiment()
            }) {
                Text("Next")
            }
            .padding(.top, 20)
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle("Experiment " + "\(vm.currentExperimentIndex + 1): " + ExperimentType.gesturePitchNumber.description)
    }
}

#Preview {
    ExperimentGestureRollGreyscaleView(vm: ExperimentViewModel(participantNumber: 1))
}
