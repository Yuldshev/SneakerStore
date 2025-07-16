import Foundation

@Observable
final class FavoritesVM {
  private let favoriteService: FavoriteServiceProtocol
  private let cartService: CartServiceProtocol
  private let router: RouterProtocol
  
  init(favoriteService: FavoriteServiceProtocol, cartService: CartServiceProtocol, router: RouterProtocol) {
    self.favoriteService = favoriteService
    self.cartService = cartService
    self.router = router
  }
  
  var sneakers: [SneakerCardModel] {
    let favoriteSneaker = favoriteService.favoriteSneakers
    
    return favoriteSneaker.map { sneaker in
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
