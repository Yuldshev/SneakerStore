import SwiftUI
import Kingfisher

struct SneakerCart: View {
  let sneaker: Sneaker
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      KFImage(sneaker.thumbnail)
        .resizable()
        .placeholder({
          Rectangle().fill(.white)
        })
        .scaledToFit()
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
      
      VStack(alignment: .leading, spacing: 4) {
        Text("$\(sneaker.price)")
          .font(.system(size: 16, weight: .bold))
        Text("\(sneaker.brand.rawValue.capitalized) \(sneaker.silhouette)")
          .font(.system(size: 12))
          .lineLimit(2)
          .opacity(0.6)
      }
      .padding(.leading, 8)
    }
  }
}

#Preview {
  let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
  
  LazyVGrid(columns: columns, spacing: 16) {
    SneakerCart(sneaker: mockSneaker.first!!)
    SneakerCart(sneaker: mockSneaker.first!!)
  }
  .padding(.horizontal, 24)
}
