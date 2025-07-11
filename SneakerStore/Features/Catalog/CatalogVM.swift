import Foundation

@Observable
@MainActor
final class CatalogVM {
  private(set) var state = CatalogState()
  
  private let sneakerService: SneakersServiceProtocol
  private let favoriteService: FavoriteServiceProtocol
  private let cartService: CartServiceProtocol
  
  private let bannerIDs = ["0f772970-8337-4fd4-9e17-002345eeb10c", "2ee22292-ceea-44dc-8278-2bda6ffd551c", "9a0a0140-68ff-4cef-a41b-66329f5ff3f5"]
  
  init(
    sneakerService: SneakersServiceProtocol = SneakersService(),
    favoriteService: FavoriteServiceProtocol = FavoriteService(),
    cartService: CartServiceProtocol = CartService()
  ) {
    self.sneakerService = sneakerService
    self.favoriteService = favoriteService
    self.cartService = cartService
    self.state = CatalogState(bannerCount: bannerIDs.count)
  }
  
  //MARK: - Publish State Sneaker
  func send(intent: CatalogIntent) async {
    switch intent {
      case .onAppear: await fetchAll()
      case .reloadCatalog: await fetchCatalog()
      case .reloadBanner(let id):
        if let index = bannerIDs.firstIndex(of: id) {
          await fetchBanner(at: index)
        }
    }
  }
  
  //MARK: - Private State Sneaker
  private func fetchAll() async {
    async let catalogResult: () = fetchCatalog()
    async let bannersResult: () = fetchBanners()
    _ = await (catalogResult, bannersResult)
  }
  
  private func fetchCatalog() async {
    state.catalogState = .loading
    
    do {
      let sneakers = try await sneakerService.fetchSneakers(count: 10)
      state.catalogState = sneakers.isEmpty ? .empty : .loaded(sneakers)
    } catch {
      state.catalogState = .error(error)
    }
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
  
  //MARK: - Favorite Sneaker
  func isFavorite(sneaker: Sneaker) -> Bool {
    favoriteService.isFavorite(sneaker: sneaker)
  }
  
  func toggleFavorite(sneaker: Sneaker) {
    favoriteService.toggleFavorite(sneaker: sneaker)
  }
  
  //MARK: - Cart Sneaker
  func isCart(sneaker: Sneaker) -> Bool {
    cartService.isCart(sneaker: sneaker)
  }
  
  func addToCart(sneaker: Sneaker) {
    cartService.addCart(sneaker: sneaker)
  }
}
