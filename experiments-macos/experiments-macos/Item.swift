//
//  Item.swift
//  experiments-macos
//
//  Created by Alexander Johansson on 17/05/2024.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Item {
    var title: String
    
    var imageName: String
    var image: Text {
        Text(imageName)
                .font(.system(size: 30))
    }
    
    init(title: String, imageName: String) {
        self.title = title
        self.imageName = imageName
    }
}
