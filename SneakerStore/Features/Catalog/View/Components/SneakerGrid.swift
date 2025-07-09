import SwiftUI

struct SneakerGrid: View {
  var sneakers: [Sneaker]
  var isFavorite: (Sneaker) -> Bool
  var toggleFavorite: (Sneaker) -> Void
  var onLastItemAppear: (() -> Void)?
  
  private let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
  
  var body: some View {
    LazyVGrid(columns: columns, spacing: 16) {
      ForEach(sneakers, id: \.id) { sneaker in
        SneakerCart(sneaker: sneaker, isFav: isFavorite(sneaker), onTapFavorite: { toggleFavorite(sneaker) })
          .onAppear {
            if sneaker.id == sneakers.last?.id {
              onLastItemAppear?()
            }
          }
      }
    }
  }
}




