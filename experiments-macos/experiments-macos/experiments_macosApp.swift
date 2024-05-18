//
//  experiments_macosApp.swift
//  experiments-macos
//
//  Created by Alexander Johansson on 17/05/2024.
//

import SwiftUI
import SwiftData
import Vapor
import Logging
import NIOCore
import NIOPosix

@main
struct experiments_macosApp: App {
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

    // Create an instance of the Server
    @StateObject private var server = Server()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(server)
                .onAppear {
                    Task { await server.start() }
                }
                .onDisappear {
                    server.stop()
                }
        }
        .modelContainer(sharedModelContainer)
    }
}

@MainActor
class Server: ObservableObject {
    @Published var isRunning: Bool = false
    @Published var ipAddress: String = "Unknown"
    @Published var port: Int = 8080
    
    private var app: Application?

    func start() async {
        do {
            var env = try Environment.detect()
            try LoggingSystem.bootstrap(from: &env)
            
            let app = try await Application.make(env)
            self.app = app
            try configure(app)
            app.http.server.configuration.port = 8080
            self.port = app.http.server.configuration.port
            
            // This must be called on the main thread
            let executorTakeoverSuccess = NIOSingletons.unsafeTryInstallSingletonPosixEventLoopGroupAsConcurrencyGlobalExecutor()
            app.logger.debug("Running with \(executorTakeoverSuccess ? "SwiftNIO" : "standard") Swift Concurrency default executor")
            
            try await app.startup()
            self.isRunning = true
            
            self.ipAddress = app.http.server.configuration.hostname
        } catch {
            print("Failed to start server: \(error)")
            self.isRunning = false
        }
    }

    func stop() {
        app?.shutdown()
        self.isRunning = false
    }

    private func configure(_ app: Application) throws {
        try routes(app)
    }
}
