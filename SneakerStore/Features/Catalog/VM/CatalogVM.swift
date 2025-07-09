import Foundation

@Observable
@MainActor
final class CatalogVM {
  private(set) var state = CatalogState()
  
  private let sneakerService: SneakersServiceProtocol
  private let favoriteService: FavoriteServiceProtocol
  private let bannerIDs = ["0f772970-8337-4fd4-9e17-002345eeb10c", "2ee22292-ceea-44dc-8278-2bda6ffd551c", "9a0a0140-68ff-4cef-a41b-66329f5ff3f5"]
  
  private(set) var isFetchingNextPage = false
  
  init(sneakerService: SneakersServiceProtocol = SneakersService(), favoriteService: FavoriteServiceProtocol = FavoriteService()) {
    self.sneakerService = sneakerService
    self.favoriteService = favoriteService
    self.state = CatalogState(bannerCount: bannerIDs.count)
  }
  
  //MARK: - Publish State Sneaker
  func handle(intent: CatalogIntent) async {
    switch intent {
      case .onAppear: await fetchAll()
      case .fetchNextPage: await fetchNextPage()
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
    sneakerService.catalogResetPagination()
    state.catalogState = .loading
    
    do {
      let sneakers = try await sneakerService.fetchNextSneakersPage()
      state.catalogState = sneakers.isEmpty ? .empty : .loaded(sneakers)
    } catch {
      state.catalogState = .error(error)
    }
  }
  
  private func fetchNextPage() async {
    guard !isFetchingNextPage else { return }
    
    isFetchingNextPage = true
    
    do {
      let newSneakers = try await sneakerService.fetchNextSneakersPage()
      if !newSneakers.isEmpty {
        if case .loaded(var currentSneakers) = state.catalogState {
          currentSneakers.append(contentsOf: newSneakers)
          state.catalogState = .loaded(currentSneakers)
        }
      } else {
        state.catalogState = .loaded(newSneakers)
      }
    } catch {
      state.catalogState = .error(error)
    }
    
    isFetchingNextPage = false
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
      let banner = try await sneakerService.fetchSneakerID(id: bannerID)
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
}
