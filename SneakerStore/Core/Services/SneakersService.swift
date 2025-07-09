import Foundation

protocol SneakersServiceProtocol {
  func fetchNextSneakersPage() async throws -> [Sneaker]
  func catalogResetPagination()
  func fetchSneakerID(id: String) async throws -> Sneaker
  func searchSneakers(name: String?, brand: SneakerBrand?, gender: SneakerGender?, sort: String?) async throws -> [Sneaker]
}

final class SneakersService: SneakersServiceProtocol {
  //MARK: - Properties
  private let networkClient: NetworkClientProtocol
  private let apiLimit = 50
  private let desiredCount = 20
  
  //MARK: - Pagination Catalog
  private var catalogCurrentPage = 0
  private var catalogHasReachedEnd = false
  
  //MARK: - Pagination Browse
  private var browseCurrentPage = 0
  private var browseHasReachedEnd = false
  
  init(network: NetworkClientProtocol = NetworkClient()) {
    self.networkClient = network
  }
  
  //MARK: - FetchNextSneakersPage
  func fetchNextSneakersPage() async throws -> [Sneaker] {
    guard !catalogHasReachedEnd else { return [] }
    
    var newValidSneakers: [Sneaker] = []
    
    while newValidSneakers.count < desiredCount  && !catalogHasReachedEnd {
      catalogCurrentPage += 1
      
      let dtos = try await fetchSneakerDTOs(limit: apiLimit, page: catalogCurrentPage)
      
      if dtos.isEmpty {
        catalogHasReachedEnd = true
        break
      }
      
      let mappedSneakers = Mapper.map(from: dtos)
      newValidSneakers.append(contentsOf: mappedSneakers)
    }
    
    return newValidSneakers
  }
  
   func catalogResetPagination() {
    catalogCurrentPage = 0
    catalogHasReachedEnd = false
  }
  
  //MARK: - Fetch SneakerID
  func fetchSneakerID(id: String) async throws -> Sneaker {
    let endpoint = SneakersEndpoint.getSneakerId(id: id)
    let response: SneakersResponse = try await networkClient.request(endpoint)
    
    guard let sneaker = Mapper.map(from: response.results).first else {
      throw NetworkError.custom(description: "Sneaker not found")
    }
    
    return sneaker
  }
  
  //MARK: - Search Sneakers
  func searchSneakers(name: String?, brand: SneakerBrand?, gender: SneakerGender?, sort: String?) async throws -> [Sneaker] {
    browseResetPagination()
    
    var foundSneakers: [Sneaker] = []
    
    while foundSneakers.count < desiredCount  && !browseHasReachedEnd {
      browseCurrentPage += 1
      
      let dtos = try await fetchSneakerDTOs(limit: apiLimit, page: browseCurrentPage, gender: gender, brand: brand, sort: sort, name: name)
      
      if dtos.isEmpty {
        browseHasReachedEnd = true
        break
      }
      
      let mapperSneakers = Mapper.map(from: dtos)
      foundSneakers.append(contentsOf: mapperSneakers)
    }
    return foundSneakers
  }
  
  private func browseResetPagination() {
    catalogCurrentPage = 0
    catalogHasReachedEnd = false
  }
  
  //MARK: - Private methods
  private func fetchSneakerDTOs(
    limit: Int,
    page: Int,
    gender: SneakerGender? = nil,
    brand: SneakerBrand? = nil,
    sort: String? = nil,
    silhouette: String? = nil,
    name: String? = nil
  ) async throws -> [SneakerDTO] {
    let endpoint = SneakersEndpoint.getSneakers(limit: limit, page: page, gender: gender?.rawValue, brand: brand?.rawValue, sort: sort, silhouette: silhouette, name: name)
    
    let response: SneakersResponse = try await networkClient.request(endpoint)
    return response.results
  }
}
