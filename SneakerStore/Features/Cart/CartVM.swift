import Foundation

@Observable
final class CartVM {
  private(set) var state: LoadingState<[Sneaker]> = .idle
  private var cartService: CartServiceProtocol
  
  init(service: CartServiceProtocol = CartService()) {
    self.cartService = service
    loadCart()
  }
  
  var sneakers: [Sneaker] {
    switch state {
      case .loaded(let data): return data
      default: return []
    }
  }
  
  func loadCart() {
    state = .loading
    
    Task {
      let items = cartService.cartSneakers
      
      if items.isEmpty {
        state = .empty
      } else {
        state = .loaded(items)
      }
    }
  }
  
  func toggleCart(_ sneaker: Sneaker) {
    cartService.addCart(sneaker: sneaker)
    loadCart()
  }
}
