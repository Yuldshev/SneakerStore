import Foundation

@Observable
@MainActor
final class BrowseVM {
  private(set) var state: LoadingState<[Sneaker]> = .idle
  
  // MARK: - Filters
  var query: String = "" { didSet { handleSearchChange() } }
  var selectedBrand: SneakerBrand?
  var selectedGender: SneakerGender?
  var selectedSort: String?
  
  private var sneakerService: SneakersServiceProtocol
  private var favoriteService: FavoriteServiceProtocol
  private var searchTask: Task<Void, Never>?
  
  init(brand: SneakerBrand? = nil, service: SneakersServiceProtocol = SneakersService(), favorite: FavoriteServiceProtocol = FavoriteService()) {
    self.selectedBrand = brand
    self.sneakerService = service
    self.favoriteService = favorite
  }
  
  // MARK: - Public Intent Handlers
  func initialLoad() {
    guard selectedBrand != nil else { return }
    performSearch()
  }
  
  func selectGender(_ gender: SneakerGender?) {
    selectedGender = gender
    performSearch()
  }
  
  func selectSort(_ sort: String) {
    if selectedSort == sort {
      selectedSort = nil
    } else {
      selectedSort = sort
    }
    performSearch()
  }
  
  // MARK: - Private Logic
  private func handleSearchChange() {
    searchTask?.cancel()
    
    searchTask = Task {
      do {
        try await Task.sleep(for: .milliseconds(500))
        
        if selectedBrand != nil {
          selectedBrand = nil
        }
        
        await performSearch()
      } catch {
        
      }
    }
  }
  
  func performSearch() {
    Task {
      await performSearch()
    }
  }
  
  private func performSearch() async {
    Task {
      guard !query.isEmpty || selectedBrand != nil else {
        state = .idle
        return
      }
      
      state = .loading
      
      do {
        let sneakers = try await sneakerService.searchSneakers(
          name: query.isEmpty ? nil : query,
          brand: selectedBrand,
          gender: selectedGender,
          sort: selectedSort
        )
        
        state = sneakers.isEmpty ? .empty : .loaded(sneakers)
      } catch is CancellationError {
        
      } catch {
        state = .error(error)
      }
    }
  }
  
  //MARK: - Favorite
  func isFavorite(sneaker: Sneaker) -> Bool {
    favoriteService.isFavorite(sneaker: sneaker)
  }
  
  func toggleFavorite(sneaker: Sneaker) {
    favoriteService.toggleFavorite(sneaker: sneaker)
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
