//
//  CircleImage.swift
//  Subjective Self Tracking
//
//  Alexander Johansson 2024
//

import SwiftUI

struct CircleImage: View {
    var image: Image

    var body: some View {
        image
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7)
    }
}

#Preview {
    CircleImage(image: Image("Prototype").resizable())
    .frame(width: 160, height: 160)
    .padding()
}
