import SwiftUI


struct ExperimentSliderGreyscaleView: View {
    @ObservedObject var vm: ExperimentViewModel

    var body: some View {
        VStack {
            Text("Experiment " + "\(vm.currentExperimentIndex + 1): " + ExperimentType.sliderGreyscale.description)
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
        .navigationTitle("Experiment " + "\(vm.currentExperimentIndex + 1): " + ExperimentType.sliderGreyscale.description)
    }
}

#Preview {
    ExperimentSliderNumberView(vm: ExperimentViewModel(participantNumber: 1))
}
