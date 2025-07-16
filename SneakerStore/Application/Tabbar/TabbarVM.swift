import Foundation

@Observable
final class TabbarVM {
  private let cartService: CartServiceProtocol
  
  init(cartService: CartServiceProtocol) {
    self.cartService = cartService
  }
  
  var cartCount: Int {
    return cartService.cartSneakers.count
  }
}
