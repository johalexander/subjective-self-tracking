//
//  Settings.swift
//  experiments-macos
//
//  Created by Alexander Johansson on 18/05/2024.
//

import SwiftUI

struct Settings: View {
    @EnvironmentObject var server: Server
    var item: Item
    
    @State private var participants = [
        Participant(age: 20, genderIdentity: "Male", completedExperiments: []),
        Participant(age: 25, genderIdentity: "Male", completedExperiments: []),
        Participant(age: 32, genderIdentity: "Male", completedExperiments: []),
        Participant(age: 24, genderIdentity: "Male", completedExperiments: []),
    ]
    
    var title: String {
        return (item.imageName) + " " + (item.title)
    }

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
                            
                            Text("Status: \(server.isRunning ? "Running" : "Stopped")")
                                .font(.headline)
                                .foregroundColor(server.isRunning ? .green : .red)
                            
                            if server.isRunning {
                                Spacer()
                                Text("IP Address: \(server.ipAddress)")
                                    .font(.callout)
                                Text("Port: \(String(server.port))")
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
                                Button(action: export) {
                                    Label("Export", systemImage: "square.and.arrow.up")
                                }
                            }
                            
                            Divider()
                            Table(participants) {
                                TableColumn("Id", value: \.id.uuidString)
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
        .navigationTitle(title)
        .frame(alignment: .top)
    }
    
    func export() {
        
    }
}


#Preview {
    Settings(item: Item(title: "Settings", imageName: "⚙️"))
        .environmentObject(Server())
}
