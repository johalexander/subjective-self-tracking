//
//  Settings.swift
//  experiments-macos
//
//  Created by Alexander Johansson on 18/05/2024.
//

import SwiftUI

struct Settings: View {
    @EnvironmentObject var server: Server

    var body: some View {
        VStack {
            Text("Server Status")
                .font(.headline)
                .padding()

            Text("Status: \(server.isRunning ? "Running" : "Stopped")")
                .font(.headline)
                .foregroundColor(server.isRunning ? .green : .red)

            if server.isRunning {
                Text("IP Address: \(server.ipAddress)")
                Text("Port: \(server.port)")
            }
        }
        .padding()
    }
}


#Preview {
    Settings()
        .environmentObject(Server())
}
