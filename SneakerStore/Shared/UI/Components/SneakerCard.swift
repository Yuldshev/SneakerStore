import SwiftUI

struct SneakerCard: View {
  var model: SneakerCardModel
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      LoaderImage(url: model.sneaker.thumbnail, resizingMode: .fill) {
        Rectangle().fill(Color(.systemGray4)).skeleton(true)
      }
        .padding()
        .frame(height: 180)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
      
      VStack(alignment: .leading, spacing: 4) {
        Text("$\(model.sneaker.price)")
          .font(.system(size: 16, weight: .bold))
          .foregroundStyle(.black)
        Text("\(model.sneaker.brand.rawValue.capitalized) \(model.sneaker.silhouette)")
          .font(.system(size: 12))
          .foregroundStyle(.black)
          .lineLimit(2)
          .opacity(0.6)
      }
      .padding(.leading, 8)
    }
    .overlay(alignment: .topTrailing) {
      ButtonAction(isBool: model.isFavorite, icon: .favorite, onTap: { model.onFavoriteTap() })
        .padding(12)
    }
  }
}

//MARK: - SneakerCardModel
struct SneakerCardModel: Identifiable {
  var id: String
  var sneaker: Sneaker
  
  var isFavorite: Bool
  var isCart: Bool
  
  var onFavoriteTap: () -> Void
  var onCartTap: () -> Void
  var onCardTap: () -> Void
}
