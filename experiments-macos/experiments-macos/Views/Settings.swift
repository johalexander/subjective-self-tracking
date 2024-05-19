//
//  Settings.swift
//  experiments-macos
//
//  Created by Alexander Johansson on 18/05/2024.
//

import SwiftUI

struct Settings: View {
    @EnvironmentObject var vm: DataViewModel

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading) {
                    GroupBox(label:
                                Label("Server", systemImage: "server.rack")
                    ) {
                        VStack(alignment: .leading) {
                            Text("This application is running a WEB server accepting requests from the external prototype device.")
                                .font(.footnote)
                            
                            Divider()
                            
                            Text("Status: \(vm.isRunning ? "Running" : "Stopped")")
                                .font(.headline)
                                .foregroundColor(vm.isRunning ? .green : .red)
                            
                            if vm.isRunning {
                                Spacer()
                                Text("IP Address: \(vm.ipAddress)")
                                    .font(.callout)
                                Text("Port: \(String(vm.port))")
                                    .font(.callout)
                            }
                        }
                        .padding(5)
                    }
                    
                    GroupBox(label:
                        Label("Participants", systemImage: "person.2")
                    ) {
                        VStack(alignment: .trailing) {
                            HStack {
                                Text("Participant data is generated when experiments are completed.")
                                    .font(.footnote)
                                Spacer()
                                Button(action: refresh) {
                                    Label("Refresh", systemImage: "arrow.clockwise")
                                }
                                Button(action: export) {
                                    Label("Export", systemImage: "square.and.arrow.up")
                                }
                            }
                            
                            Divider()
                            Table(vm.participants) {
                                TableColumn("Id", value: \.id)
                                TableColumn("Age", value: \.ageString)
                                TableColumn("Gender identity", value: \.genderIdentity)
                                TableColumn("Completed experiments", value: \.count)
                            }
                            .padding(0)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                        .padding(5)
                    }
                    .frame(height: 300)
                    .padding(0)
                }
                .padding()
            }
        }
        .navigationTitle("⚙️ Settings")
        .frame(alignment: .top)
    }
    
    func export() {
        vm.loadParticipantData()
    }
    
    func refresh() {
        vm.loadParticipantData()
    }
}


#Preview {
    Settings()
        .environmentObject(DataViewModel())
}
