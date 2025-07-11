import SwiftUI

struct SneakerCard: View {
  var sneaker: Sneaker
  var isFav: Bool = false
  var onTapFavorite: () -> Void = {}
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      LoaderImage(url: sneaker.thumbnail, resizingMode: .fill)
        .padding()
        .frame(height: 180)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
      
      VStack(alignment: .leading, spacing: 4) {
        Text("$\(sneaker.price)")
          .font(.system(size: 16, weight: .bold))
          .foregroundStyle(.black)
        Text("\(sneaker.brand.rawValue.capitalized) \(sneaker.silhouette)")
          .font(.system(size: 12))
          .foregroundStyle(.black)
          .lineLimit(2)
          .opacity(0.6)
      }
      .padding(.leading, 8)
    }
    .overlay(alignment: .topTrailing) {
      ButtonAction(isBool: isFav, icon: .favorite, onTap: { onTapFavorite() })
        .padding(12)
    }
  }
}

