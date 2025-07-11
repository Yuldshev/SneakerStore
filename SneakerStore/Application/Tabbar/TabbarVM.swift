import Foundation

@Observable
final class TabbarVM {
  private var cartService: CartServiceProtocol
  
  init(service: CartServiceProtocol = CartService()) {
    self.cartService = service
  }
  
  var cartCount: Int {
    return cartService.cartSneakers.count
  }
}
