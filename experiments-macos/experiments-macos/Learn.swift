//
//  NavigationDetails.swift
//  experiments-macos
//
//  Created by Alexander Johansson on 18/05/2024.
//

import Foundation
import SwiftUI

struct Learn: View {
    @Environment(ModelData.self) var modelData
    var item: Item
    
    var title: String {
        return (item.imageName) + " " + (item.title)
    }

    var body: some View {
        @Bindable var modelData = modelData

        NavigationStack {
            ScrollView {
                Text("Learn")
                
                NavigationLink("Go deeper") {
                    Text("ONE one level deeper")
                }
                .navigationTitle(title)
            }
        }
        .navigationTitle(title)
    }
}

#Preview {
    Learn(item: Item(title: "Learn", imageName: "💪🏻"))
        .environment(ModelData())
}
