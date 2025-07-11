import Foundation

protocol CartServiceProtocol {
  func isCart(sneaker: Sneaker) -> Bool
  func addCart(sneaker: Sneaker)
  func getCart() -> [Sneaker]
  var cartSneakers: [Sneaker] { get }
}

final class CartService: CartServiceProtocol {
  private var cacheService: CacheServiceProtocol
  private var cacheKey = "cart_sneakers"
  
  private(set) var cartSneakers: [Sneaker] = []
  
  init(cacheService: CacheServiceProtocol = CacheService()) {
    self.cacheService = cacheService
    Task { await loadCartFromCache()}
  }
  
  func isCart(sneaker: Sneaker) -> Bool {
    cartSneakers.contains(where: { $0.id == sneaker.id })
  }
  
  func addCart(sneaker: Sneaker) {
    if isCart(sneaker: sneaker) {
      cartSneakers.removeAll(where: { $0.id == sneaker.id })
    } else {
      cartSneakers.append(sneaker)
    }
    // Save cache
    Task { await saveCartToCache() }
  }
  
  func getCart() -> [Sneaker] {
    cartSneakers
  }
  
  //MARK: - Private Methods
  private func loadCartFromCache() async {
    self.cartSneakers = await cacheService.loadCache(key: cacheKey, as: [Sneaker].self) ?? []
  }
  
  private func saveCartToCache() async {
    await cacheService.saveCache(cartSneakers, key: cacheKey)
  }
}
