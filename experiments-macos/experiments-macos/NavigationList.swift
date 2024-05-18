//
//  NavigationList.swift
//  experiments-macos
//
//  Created by Alexander Johansson on 18/05/2024.
//

import Foundation
import SwiftUI

struct NavigationList: View {
    @Environment(ModelData.self) var modelData
    @EnvironmentObject var server: Server
    @State private var selectedItem: Item?
    
    @State var contentSelection: ContentSelection?
    @State var columnVisibility: NavigationSplitViewVisibility = .doubleColumn
    
    var title: String {
        return (selectedItem?.imageName ?? "") + (selectedItem?.title ?? "")
    }
    
    enum ContentSelection: Hashable {
        case one
        case two
    }

    var body: some View {
        @Bindable var modelData = modelData
        
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection: $selectedItem) {
                let item = modelData.navItems[0]
                NavigationLink {
                    Learn(item: item)
                } label: {
                    NavigationItem(item: item)
                }
                .tag(item)
                
                let item2 = modelData.navItems[1]
                NavigationLink {
                    Experiments(item: item2)
                } label: {
                    NavigationItem(item: item2)
                }
                .tag(item2)
                
                let item3 = modelData.navItems[2]
                NavigationLink {
                    Settings()
                        .environmentObject(server)
                } label: {
                    NavigationItem(item: item3)
                }
                .tag(item3)
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            .navigationTitle(title)
            .onAppear {
                if selectedItem == nil, let firstItem = modelData.navItems.first {
                    selectedItem = firstItem
                }
            }
        } detail: {
            
        }
    }
}

#Preview {
    NavigationList()
        .environment(ModelData())
        .environmentObject(Server())
}

