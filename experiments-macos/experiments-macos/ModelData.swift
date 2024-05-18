//
//  ModelData.swift
//  experiments-macos
//
//  Created by Alexander Johansson on 18/05/2024.
//

import Foundation
 
@Observable
class ModelData {
    var navItems: [Item] = [
        Item(title: "Learn", imageName: "💪🏻"),
        Item(title: "Experiments", imageName: "🧪"),
        Item(title: "Settings", imageName: "⚙️"),
    ]
}
