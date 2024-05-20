//
//  experiments_macosApp.swift
//  experiments-macos
//
//  Created by Alexander Johansson on 17/05/2024.
//

import SwiftUI
import SwiftData

@main
struct SubjectiveSelfTrackingApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    private var server = Server()
    @StateObject private var vm = DataViewModel.sharedSingleton

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
                .onAppear {
                    Task { await server.start() }
                }
                .onDisappear {
                    server.stop()
                }
                .frame(minWidth: 1024, minHeight: 800)
        }
        .modelContainer(sharedModelContainer)
        .windowResizability(.contentSize)
    }
}
