import SwiftUI

struct SneakerGrid: View {
  var sneakers: [Sneaker]
  
  var isFavorite: (Sneaker) -> Bool
  var toggleFavorite: (Sneaker) -> Void
  var isCart: (Sneaker) -> Bool
  var toggleCart: (Sneaker) -> Void
  
  @Environment(\.router) var router
  
  private let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
  
  var body: some View {
    LazyVGrid(columns: columns, spacing: 16) {
      ForEach(sneakers, id: \.id) { sneaker in
        Button {
          router.showScreen(.push) { _ in
            SneakerDetail(
              sneaker: sneaker,
              isFavorite: isFavorite(sneaker),
              onFavoriteTapped: { toggleFavorite(sneaker) },
              isCart: isCart(sneaker),
              onCartTapped: { toggleCart(sneaker) }
            )
          }
        } label: {
          SneakerCard(
            sneaker: sneaker,
            isFav: isFavorite(sneaker),
            onTapFavorite: { toggleFavorite(sneaker) }
          )
        }
      }
    }
  }
}




