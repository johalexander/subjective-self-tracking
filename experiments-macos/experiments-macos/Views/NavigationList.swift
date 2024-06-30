//
//  NavigationList.swift
//  Subjective Self Tracking
//
//  Alexander Johansson 2024
//

import Foundation
import SwiftUI

struct NavigationList: View {
    @EnvironmentObject var vm: DataViewModel
    @EnvironmentObject var evm: ExperimentViewModel
    @State private var selectedItem: Item?
    
    @State var columnVisibility: NavigationSplitViewVisibility = .doubleColumn
    
    var title: String {
        return (selectedItem?.imageName ?? "") + (selectedItem?.title ?? "")
    }

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection: $selectedItem) {
                let item = vm.navItems[0]
                NavigationLink {
                    Learn()
                        .environmentObject(vm)
                } label: {
                    NavigationItem(item: item)
                }
                .tag(item)
                
                let item2 = vm.navItems[1]
                NavigationLink {
                    Experiments()
                        .environmentObject(vm)
                        .environmentObject(evm)
                } label: {
                    NavigationItem(item: item2)
                }
                .tag(item2)
                
                let item3 = vm.navItems[2]
                NavigationLink {
                    Settings()
                        .environmentObject(vm)
                } label: {
                    NavigationItem(item: item3)
                }
                .tag(item3)
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            .navigationTitle(title)
            .onAppear {
                if selectedItem == nil, let firstItem = vm.navItems.first {
                    selectedItem = firstItem
                }
            }
        } detail: {
            
        }
    }
}

#Preview {
    NavigationList()
        .environmentObject(DataViewModel())
        .environmentObject(ExperimentViewModel(participantNumber: readParticipantCount() + 1))
}

