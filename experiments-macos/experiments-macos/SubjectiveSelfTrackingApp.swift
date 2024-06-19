//
//  experiments_macosApp.swift
//  experiments-macos
//
//  Created by Alexander Johansson on 17/05/2024.
//

import SwiftUI

@main
struct SubjectiveSelfTrackingApp: App {
    @StateObject private var vm = DataViewModel.sharedSingleton
    @StateObject private var evm = ExperimentViewModel(participantNumber: readParticipantCount() + 1)
    private var server = Server()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
                .environmentObject(evm)
                .onAppear {
                    Task { await server.start() }
                }
                .onDisappear {
                    server.stop()
                }
                .frame(minWidth: 1024, minHeight: 800)
        }
        .windowResizability(.contentSize)
    }
}
