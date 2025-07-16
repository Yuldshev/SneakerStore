import Foundation

protocol FavoriteServiceProtocol {
  var favoriteSneakers: [Sneaker] { get }
  func isFavorite(_ sneaker: Sneaker) -> Bool
  func toggleFavorite(_ sneaker: Sneaker)
}

@Observable
final class FavoriteService: FavoriteServiceProtocol {
  private let collectionService: UserCollectionServiceProtocol
  
  init(collectionService: UserCollectionServiceProtocol) {
    self.collectionService = collectionService
  }
  
  var favoriteSneakers: [Sneaker] {
    collectionService.sneakers
  }
  
  func isFavorite(_ sneaker: Sneaker) -> Bool {
    collectionService.contains(sneaker)
  }
  
  func toggleFavorite(_ sneaker: Sneaker) {
    collectionService.toggle(sneaker)
  }
}
