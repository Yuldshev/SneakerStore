import Foundation

protocol FavoriteServiceProtocol {
  func isFavorite(sneaker: Sneaker) -> Bool
  func toggleFavorite(sneaker: Sneaker)
  func getFavorites() -> [Sneaker]
  var favoriteSneakers: [Sneaker] { get }
}

@Observable
final class FavoriteService: FavoriteServiceProtocol {
  private var cacheService: CacheServiceProtocol
  private let cacheKey = "favorite_sneakers"
  
  private(set) var favoriteSneakers: [Sneaker] = []
  
  init(cacheService: CacheServiceProtocol = CacheService()) {
    self.cacheService = cacheService
    Task { await loadFavoritesFromCache() }
  }
  
  //MARK: - Public methods
  func isFavorite(sneaker: Sneaker) -> Bool {
    favoriteSneakers.contains { $0.id == sneaker.id }
  }
  
  func toggleFavorite(sneaker: Sneaker) {
    if isFavorite(sneaker: sneaker) {
      favoriteSneakers.removeAll { $0.id == sneaker.id }
    } else {
      favoriteSneakers.append(sneaker)
    }
    
    Task { await saveFavoritesToCache() }
  }
  
  func getFavorites() -> [Sneaker] {
    return favoriteSneakers
  }
  
  //MARK: - Private Methods
  private func loadFavoritesFromCache() async {
    self.favoriteSneakers = await cacheService.loadCache(key: cacheKey, as: [Sneaker].self) ?? []
  }
  
  private func saveFavoritesToCache() async {
    await cacheService.saveCache(favoriteSneakers, key: cacheKey)
  }
}
