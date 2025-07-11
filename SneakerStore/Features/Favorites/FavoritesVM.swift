import Foundation

@Observable
final class FavoritesVM {
  private(set) var state: LoadingState<[Sneaker]> = .idle
  private let favoriteService: FavoriteServiceProtocol
  
  init(service: FavoriteServiceProtocol = FavoriteService()) {
    self.favoriteService = service
    loadFavorites()
  }
  
  var sneakers: [Sneaker] {
    switch state {
      case .loaded(let data): return data
      default: return []
    }
  }
  
  func loadFavorites() {
    state = .loading
    
    Task {
      let items = favoriteService.favoriteSneakers
      
      if items.isEmpty {
        state = .empty
      } else {
        state = .loaded(items)
      }
    }
  }
  
  func toggleFavorite(_ sneaker: Sneaker) {
    favoriteService.toggleFavorite(sneaker: sneaker)
    loadFavorites()
  }
}
