import Foundation

@Observable
final class CatalogVM {
  private(set) var state = CatalogState()
  
  private let sneakerService: SneakersServiceProtocol
  private let bannerIDs = ["05915db1-b0a6-4459-bc52-d75ce619244f", "390d6dfe-b1b8-4cd5-a80d-1716a6431741", "ff2f7803-58ce-495f-9d39-1738aa24e7ac"]
  
  init(sneakerService: SneakersServiceProtocol = SneakersService()) {
    self.sneakerService = sneakerService
    self.state = CatalogState(bannerCount: bannerIDs.count)
  }
  
  @MainActor
  func handle(intent: CatalogIntent) async {
    switch intent {
      case .onAppear: await fetchAll()
      case .reloadCatalog: await fetchCatalog()
      case .reloadBanner(let id):
        if let index = bannerIDs.firstIndex(of: id) {
          await fetchBanner(at: index)
        }
    }
  }
  
  @MainActor
  private func fetchAll() async {
    async let catalogResult: () = fetchCatalog()
    async let bannersResult: () = fetchBanners()
    _ = await (catalogResult, bannersResult)
  }
  
  @MainActor
  private func fetchCatalog() async {
    state.catalogState = .loading
    
    do {
      let sneakers = try await sneakerService.fetchSneakers(
        limit: 20,
        page: 1,
        gender: nil,
        brand: nil,
        sort: nil,
        silhouette: nil,
        name: nil
      )
      state.catalogState = sneakers.isEmpty ? .empty : .loaded(sneakers)
    } catch {
      state.catalogState = .error(error)
    }
  }
  
  @MainActor
  private func fetchBanners() async {
    await withTaskGroup(of: Void.self) { group in
      for i in 0..<bannerIDs.count {
        group.addTask {
          await self.fetchBanner(at: i)
        }
      }
    }
  }
  
  @MainActor
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
}
