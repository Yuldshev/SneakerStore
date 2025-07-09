import Foundation

@Observable
@MainActor
final class FavoritesVM {
  private let favoriteService: FavoriteServiceProtocol
  
  init(service: FavoriteServiceProtocol = FavoriteService()) {
    self.favoriteService = service
  }
  
  var sneakers: [Sneaker] {
    favoriteService.favoriteSneakers
  }
  
  func toggleFavorite(_ sneaker: Sneaker) {
    favoriteService.toggleFavorite(sneaker: sneaker)
  }
}
