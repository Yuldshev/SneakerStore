import Foundation

@Observable
@MainActor
final class BrowseVM {
  private(set) var state: BrowseState
  private(set) var isRefreshing: Bool = false
  
  // MARK: - Filters
  var selectedBrand: SneakerBrand?
  var selectedGender: SneakerGender = .men
  var selectedSort: String?
  
  private let sneakerService: SneakersServiceProtocol
  private let favoriteService: FavoriteServiceProtocol
  private let cartService: CartServiceProtocol
  private let router: RouterProtocol
  
  init(
    brand: SneakerBrand,
    sneakerService: SneakersServiceProtocol,
    favoriteService: FavoriteServiceProtocol,
    cartService: CartServiceProtocol,
    router: RouterProtocol
  ) {
    self.selectedBrand = brand
    self.sneakerService = sneakerService
    self.favoriteService = favoriteService
    self.cartService = cartService
    self.router = router
    self.state = BrowseState()
  }
  
  // MARK: - Public Intent Handlers
  func send(intent: BrowseIntent) async {
    switch intent {
      case .onAppear:
        await fetchSneakers(true)
      case .reload:
        await fetchSneakers()
    }
  }
  
  func makeCardModel(_ sneaker: Sneaker) -> SneakerCardModel {
    SneakerCardModel(
      id: sneaker.id,
      sneaker: sneaker,
      isFavorite: favoriteService.isFavorite(sneaker),
      isCart: cartService.isCart(sneaker: sneaker),
      onFavoriteTap: { self.favoriteService.toggleFavorite(sneaker)},
      onCartTap: { self.cartService.addCart(sneaker: sneaker)},
      onCardTap: {
        let model = self.makeCardModel(sneaker)
        Task { await self.router.showSneakerDetail(model: model) }
      }
    )
  }
  
  var sneakerCards: [SneakerCardModel] {
    if case .loaded(let sneakers) = state.loadingState {
      return sneakers.map { makeCardModel($0) }
    }
    
    return []
  }
  
  // MARK: - Private Logic
  private func fetchSneakers(_ isInitLoad: Bool = false) async {
    if isInitLoad { state.loadingState = .loading }
    isRefreshing = true
    
    do {
      let sneakers = try await sneakerService.searchSneakers(brand: selectedBrand, gender: selectedGender, sort: selectedSort, count: 10)
      state.loadingState = sneakers.isEmpty ? .empty : .loaded(sneakers)
    } catch {
      state.loadingState = .error(error)
    }
    isRefreshing = false
  }
}

//MARK: - Helper Struct for UI
extension BrowseVM {
  struct GenderOption: Hashable, Identifiable {
    let id = UUID()
    let name: String
    let value: SneakerGender?
  }
}
