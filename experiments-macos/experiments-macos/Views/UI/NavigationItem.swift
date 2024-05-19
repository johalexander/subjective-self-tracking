//
//  NavigationItem.swift
//  experiments-macos
//
//  Created by Alexander Johansson on 18/05/2024.
//

import Foundation
import SwiftUI

struct NavigationItem: View {
    var item: Item
    
    var body: some View {
        HStack {
            item.image
            
            VStack(alignment: .leading) {
                Text(item.title)
                    .fontWeight(.semibold)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    return Group {
        NavigationItem(item: Item(title: "Train", imageName: "💪🏻"))
        NavigationItem(item: Item(title: "Experiments", imageName: "🧪"))
    }
}
