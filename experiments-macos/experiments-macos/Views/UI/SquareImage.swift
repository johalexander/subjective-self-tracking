import SwiftUI

struct SquareImage: View {
    var image: Image

    var body: some View {
        image
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20).stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7)
    }
}

#Preview {
    SquareImage(image: Image("Prototype").resizable())
    .frame(width: 160, height: 160)
    .padding()
}
