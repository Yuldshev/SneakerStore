import Foundation

@Observable
final class SneakerDetailVM {
  let sneaker: Sneaker
  
  private let favoriteService: FavoriteServiceProtocol
  private let cartService: CartServiceProtocol
  
  init(sneaker: Sneaker, favoriteService: FavoriteServiceProtocol, cartService: CartServiceProtocol) {
    self.sneaker = sneaker
    self.favoriteService = favoriteService
    self.cartService = cartService
  }
  
  var isFavorite: Bool {
    favoriteService.isFavorite(sneaker)
  }
  
  var isCart: Bool {
    cartService.isCart(sneaker: sneaker)
  }
  
  func onFavoriteTap() {
    favoriteService.toggleFavorite(sneaker)
  }
  
  func onCartTap() {
    cartService.addCart(sneaker: sneaker)
  }
}
