import Foundation

@Observable
@MainActor
final class CatalogVM {
  private(set) var state = CatalogState()
  
  private let sneakerService: SneakersServiceProtocol
  private let favoriteService: FavoriteServiceProtocol
  private let cartService: CartServiceProtocol
  private let router: RouterProtocol
  
  private let bannerIDs = ["0f772970-8337-4fd4-9e17-002345eeb10c", "2ee22292-ceea-44dc-8278-2bda6ffd551c", "9a0a0140-68ff-4cef-a41b-66329f5ff3f5"]
  
  init(
    sneakerService: SneakersServiceProtocol,
    favoriteService: FavoriteServiceProtocol,
    cartService: CartServiceProtocol,
    router: RouterProtocol
  ) {
    self.sneakerService = sneakerService
    self.favoriteService = favoriteService
    self.cartService = cartService
    self.router = router
    self.state = CatalogState(bannerCount: bannerIDs.count)
  }
  
  //MARK: - Publish State Sneaker
  func send(intent: CatalogIntent) async {
    switch intent {
      case .onAppear: await fetchAll()
      case .reloadCatalog: await fetchCatalog(false)
      case .reloadBanner(let id):
        if let index = bannerIDs.firstIndex(of: id) {
          await fetchBanner(at: index)
        }
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
  
  func handleBannerTap(_ sneaker: Sneaker) {
    let model = makeCardModel(sneaker)
    Task { await router.showSneakerDetail(model: model) }
  }
  
  //MARK: - Private State Sneaker
  private func fetchAll() async {
    state.catalogState = .loading
    state.bannerStates = Array(repeating: .loading, count: bannerIDs.count)
    
    async let catalogResult: () = fetchCatalog(true)
    async let bannersResult: () = fetchBanners()
    _ = await (catalogResult, bannersResult)
  }
  
  private func fetchCatalog(_ isInitLoad: Bool) async {
    if isInitLoad { state.catalogState = .loading }
    state.isRefreshing = true
    
    do {
      let sneakers = try await sneakerService.fetchSneakers(count: 10)
      state.catalogState = sneakers.isEmpty ? .empty : .loaded(sneakers)
    } catch {
      state.catalogState = .error(error)
    }
    state.isRefreshing = false
  }
  
  private func fetchBanners() async {
    await withTaskGroup(of: Void.self) { group in
      for i in 0..<bannerIDs.count {
        group.addTask {
          await self.fetchBanner(at: i)
        }
      }
    }
  }
  
  private func fetchBanner(at index: Int) async {
    guard index < state.bannerStates.count else { return }
    
    state.bannerStates[index] = .loading
    let bannerID = bannerIDs[index]
    
    do {
      let banner = try await sneakerService.fetchSneaker(id: bannerID)
      state.bannerStates[index] = .loaded(banner)
    } catch {
      let notFoundError = NSError(domain: "CatalogVM", code: 404, userInfo: [NSLocalizedDescriptionKey: "Banner not found"])
      state.bannerStates[index] = .error(notFoundError)
      
    }
  }
  
  //MARK: - SneakerCard
  var sneakerCards: [SneakerCardModel] {
    if case .loaded(let sneakers) = state.catalogState {
      return sneakers.map { makeCardModel($0) }
    }
    
    return []
  }
}
