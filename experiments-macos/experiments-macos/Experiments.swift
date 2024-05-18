//
//  Experiments.swift
//  experiments-macos
//
//  Created by Alexander Johansson on 18/05/2024.
//

import Foundation
import SwiftUI

struct Experiments: View {
    @Environment(ModelData.self) var modelData
    var item: Item
    
    var title: String {
        return (item.imageName) + " " + (item.title)
    }

    var body: some View {
        @Bindable var modelData = modelData

        NavigationStack {
            ScrollView {
                Text("Hey")
                
                NavigationLink("ONE") {
                    Text("ONE one level deeper")
                }
            }
        }
        .navigationTitle(title)
    }
}

#Preview {
    Experiments(item: Item(title: "Learn", imageName: "💪🏻"))
        .environment(ModelData())
}
