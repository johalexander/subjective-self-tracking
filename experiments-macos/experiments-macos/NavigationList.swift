//
//  NavigationList.swift
//  experiments-macos
//
//  Created by Alexander Johansson on 18/05/2024.
//

import Foundation
import SwiftUI

struct NavigationList: View {
    @EnvironmentObject var server: Server
    @EnvironmentObject var manager: DataModelManager
    @State private var selectedItem: Item?
    
    @State var columnVisibility: NavigationSplitViewVisibility = .doubleColumn
    
    var title: String {
        return (selectedItem?.imageName ?? "") + (selectedItem?.title ?? "")
    }

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection: $selectedItem) {
                let item = manager.navItems[0]
                NavigationLink {
                    Learn(item: item)
                        .environmentObject(manager)
                } label: {
                    NavigationItem(item: item)
                }
                .tag(item)
                
                let item2 = manager.navItems[1]
                NavigationLink {
                    Experiments(item: item2)
                } label: {
                    NavigationItem(item: item2)
                }
                .tag(item2)
                
                let item3 = manager.navItems[2]
                NavigationLink {
                    Settings(item: item3)
                        .environmentObject(server)
                } label: {
                    NavigationItem(item: item3)
                }
                .tag(item3)
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            .navigationTitle(title)
            .onAppear {
                if selectedItem == nil, let firstItem = manager.navItems.first {
                    selectedItem = firstItem
                }
            }
        } detail: {
            
        }
    }
}

#Preview {
    NavigationList()
        .environmentObject(Server())
        .environmentObject(DataModelManager())
}

