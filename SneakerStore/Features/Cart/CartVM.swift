import Foundation

@Observable
final class CartVM {
  private let cartService: CartServiceProtocol
  private let favoriteService: FavoriteServiceProtocol
  private let router: RouterProtocol
  
  init(cartService: CartServiceProtocol, favoriteService: FavoriteServiceProtocol, router: RouterProtocol) {
    self.cartService = cartService
    self.favoriteService = favoriteService
    self.router = router
  }
  
  var sneakers: [SneakerCardModel] {
    let cartSneakers = cartService.cartSneakers
    
    return cartSneakers.map { sneaker in
      makeCardModel(sneaker)
    }
  }
  
  var state: LoadingState<[SneakerCardModel]> {
    sneakers.isEmpty ? .empty : .loaded(sneakers)
  }
  
  func makeCardModel(_ sneaker: Sneaker) -> SneakerCardModel {
    SneakerCardModel(
      id: sneaker.id,
      sneaker: sneaker,
      isFavorite: favoriteService.isFavorite(sneaker),
      isCart: cartService.isCart(sneaker: sneaker),
      onFavoriteTap: { self.favoriteService.toggleFavorite(sneaker)},
      onCartTap: { self.cartService.addCart(sneaker: sneaker) },
      onCardTap: {
        let model = self.makeCardModel(sneaker)
        Task { await self.router.showSneakerDetail(model: model) }
      }
    )
  }
}
