//
//  ContentView.swift
//  experiments-macos
//
//  Created by Alexander Johansson on 17/05/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var server: Server
    @EnvironmentObject var manager: DataModelManager
    
    var body: some View {
        NavigationList()
            .environmentObject(server)
            .environmentObject(manager)
    }
}

#Preview {
    ContentView()
        .environmentObject(Server())
        .environmentObject(DataModelManager())
}
