//
//  Settings.swift
//  experiments-macos
//
//  Created by Alexander Johansson on 18/05/2024.
//

import SwiftUI

struct Settings: View {
    @EnvironmentObject var vm: DataViewModel
    
    @State private var showConfirmationDialog = false
    @State private var sortOrder = [KeyPathComparator(\Participant.id)]

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
                                Button(action: {
                                    vm.exportParticipantData()
                                }) {
                                    Label("Export", systemImage: "square.and.arrow.up")
                                }
                                Button(action: {
                                    showConfirmationDialog = true
                                }) {
                                    Label("Delete All", systemImage: "trash")
                                }
                                    .tint(.red)
                                    .buttonStyle(.borderedProminent)
                                    .confirmationDialog("Are you sure you want to delete all data?", isPresented: $showConfirmationDialog) {
                                            Button("Delete All", role: .destructive) {
                                                vm.deleteAllData()
                                            }
                                            Button("Cancel", role: .cancel) {}
                                        }
                            }
                            
                            Divider()
                            Table(vm.participants, sortOrder: $sortOrder) {
                                TableColumn("Id", value: \.id)
                                TableColumn("Age", value: \.age)
                                TableColumn("Gender identity", value: \.genderIdentity)
                                TableColumn("Completed experiments", value: \.totalExperimentCount)
                                TableColumn("Total stimuli", value: \.totalStimuliCount)
                                
                            }
                            .padding(0)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .onChange(of: sortOrder) { oldOrder, newOrder in
                                vm.participants.sort(using: newOrder)
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("Saved participant count: \(vm.participantCount)")
                                    .font(.footnote)
                                Spacer()
                                Button(action: {
                                    vm.showSetCountAlert = true
                                }) {
                                    Label("Set Count", systemImage: "number")
                                }
                            }
                            .padding(.top, 2)
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
        .onAppear {
            vm.loadParticipantData()
            vm.participants.sort(using: sortOrder)
        }
        .alert(isPresented: $vm.showAlert) {
            Alert(title: Text(vm.alertTitle), message: Text(vm.alertMessage), dismissButton: .default(Text("OK")))
        }
        .alert("Set Participant Count", isPresented: $vm.showSetCountAlert) {
            TextField("Enter new participant count", text: $vm.newParticipantCount)
            Button("Save", action: {
                vm.updateParticipantCount()
            })
            Button("Cancel", role: .cancel) {}
        }
    }
}


#Preview {
    Settings()
        .environmentObject(DataViewModel())
}
