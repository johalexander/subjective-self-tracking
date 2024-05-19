//
//  ContentView.swift
//  experiments-macos
//
//  Created by Alexander Johansson on 17/05/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var vm: DataViewModel
    
    var body: some View {
        NavigationList()
            .environmentObject(vm)
    }
}

#Preview {
    ContentView()
        .environmentObject(DataViewModel())
}
