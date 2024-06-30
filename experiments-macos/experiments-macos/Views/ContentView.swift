//
//  ContentView.swift
//  Subjective Self Tracking
//
//  Alexander Johansson 2024
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var vm: DataViewModel
    @EnvironmentObject var evm: ExperimentViewModel
    
    var body: some View {
        NavigationList()
            .environmentObject(vm)
            .environmentObject(evm)
    }
}

#Preview {
    ContentView()
        .environmentObject(DataViewModel())
        .environmentObject(ExperimentViewModel(participantNumber: readParticipantCount() + 1))
}
