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
    
    var body: some View {
        NavigationList()
            .environment(ModelData())
            .environmentObject(server)
    }
}

#Preview {
    ContentView()
        .environment(ModelData())
}
