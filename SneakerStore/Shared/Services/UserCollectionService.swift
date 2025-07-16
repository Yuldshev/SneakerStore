import Foundation

protocol UserCollectionServiceProtocol {
  var sneakers: [Sneaker] { get }
  func contains(_ sneaker: Sneaker) -> Bool
  func toggle(_ sneaker: Sneaker)
}

@Observable
final class UserCollectionService: UserCollectionServiceProtocol {
  private(set) var sneakers: [Sneaker] = []
  private let cacheService: CacheServiceProtocol
  private let cacheKey: String
  
  init(cacheService: CacheServiceProtocol, cacheKey: String) {
    self.cacheService = cacheService
    self.cacheKey = cacheKey
    
    Task { await loadFromCache() }
  }
  
  //MARK: - Public methods
  func contains(_ sneaker: Sneaker) -> Bool {
    sneakers.contains { $0.id == sneaker.id }
  }
  
  func toggle(_ sneaker: Sneaker) {
    if contains(sneaker) {
      sneakers.removeAll { $0.id == sneaker.id }
    } else {
      sneakers.append(sneaker)
    }
    
    Task { await saveToCache() }
  }
  
  //MARK: - Private methods
  private func loadFromCache() async {
    self.sneakers = await cacheService.loadCache(key: cacheKey, as: [Sneaker].self) ?? []
  }
  
  private func saveToCache() async {
    await cacheService.saveCache(sneakers, key: cacheKey)
  }
}
