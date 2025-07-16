import Foundation

protocol CartServiceProtocol {
  var cartSneakers: [Sneaker] { get }
  func isCart(sneaker: Sneaker) -> Bool
  func addCart(sneaker: Sneaker)
}

@Observable
final class CartService: CartServiceProtocol {
  private var collectionService: UserCollectionServiceProtocol
  
  init(collectionService: UserCollectionServiceProtocol) {
    self.collectionService = collectionService
  }
  
  var cartSneakers: [Sneaker] {
    collectionService.sneakers
  }
  
  func isCart(sneaker: Sneaker) -> Bool {
    collectionService.contains(sneaker)
  }
  
  func addCart(sneaker: Sneaker) {
    collectionService.toggle(sneaker)
  }
}
