import Foundation

//MARK: - State
struct CatalogState {
  var catalogState: LoadingState<[Sneaker]> = .idle
  var bannerStates: [LoadingState<Sneaker>] = []
  var isRefreshing: Bool = false
  
  init(bannerCount: Int = 3) {
    self.bannerStates = Array(repeating: .idle, count: bannerCount)
  }
  
  var isInitialLoading: Bool {
    if case .loading = catalogState { return true }
    return false
  }
}

//MARK: - Intent
enum CatalogIntent {
  case onAppear
  case reloadCatalog
  case reloadBanner(id: String)
}
