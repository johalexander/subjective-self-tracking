//
//  NavigationItem.swift
//  Subjective Self Tracking
//
//  Alexander Johansson 2024
//

import Foundation
import SwiftUI

struct NavigationItem: View {
    var item: Item
    
    var body: some View {
        HStack {
            Text(item.imageName)
                    .font(.system(size: 30))
            
            VStack(alignment: .leading) {
                Text(item.title)
                    .fontWeight(.semibold)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct Item: Hashable {
    var title: String
    var imageName: String
    
    init(title: String, imageName: String) {
        self.title = title
        self.imageName = imageName
    }
}

#Preview {
    return Group {
        NavigationItem(item: Item(title: "Train", imageName: "💪🏻"))
        NavigationItem(item: Item(title: "Experiments", imageName: "🧪"))
    }
}
