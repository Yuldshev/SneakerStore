import Foundation
import SwiftfulRouting

@MainActor
struct VMFactory {
  private static let container = DIContainer.shared
  
  static func makeCatalog(router: AnyRouter) -> CatalogVM {
    CatalogVM(sneakerService: container.sneakerService, favoriteService: container.favoriteService, cartService: container.cartService, router: Router(router: router))
  }
  
  static func makeBrowse(brand: SneakerBrand, router: AnyRouter) -> BrowseVM {
    BrowseVM(brand: brand, sneakerService: container.sneakerService, favoriteService: container.favoriteService, cartService: container.cartService, router: Router(router: router))
  }
  
  static func makeFavorite(router: AnyRouter) -> FavoritesVM {
    FavoritesVM(favoriteService: container.favoriteService, cartService: container.cartService, router: Router(router: router))
  }
  
  static func makeCart(router: AnyRouter) -> CartVM {
    CartVM(cartService: container.cartService, favoriteService: container.favoriteService, router: Router(router: router))
  }
  
  static func makeTab() -> TabbarVM {
    TabbarVM(cartService: container.cartService)
  }
  
  static func makeDetailVM(sneaker: Sneaker) -> SneakerDetailVM {
    SneakerDetailVM(sneaker: sneaker, favoriteService: container.favoriteService, cartService: container.cartService)
  }
}
