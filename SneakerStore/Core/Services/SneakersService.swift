import Foundation

protocol SneakersServiceProtocol {
  func fetchSneakers(limit: Int, page: Int, gender: SneakerGender?, brand: SneakerBrand?, sort: String?, silhouette: String?, name: String?) async throws -> [Sneaker]
  func fetchSneakerID(id: String) async throws -> Sneaker
}

final class SneakersService: SneakersServiceProtocol {
  private let networkClient: NetworkClientProtocol
  
  init(network: NetworkClientProtocol = NetworkClient()) {
    self.networkClient = network
  }
  
  func fetchSneakers(
    limit: Int,
    page: Int,
    gender: SneakerGender?,
    brand: SneakerBrand?,
    sort: String?,
    silhouette: String?,
    name: String?
  ) async throws -> [Sneaker] {
    let endpoint = SneakersEndpoint.getSneakers(
      limit: limit,
      page: page,
      gender: gender?.rawValue,
      brand: brand?.rawValue,
      sort: sort,
      silhouette: silhouette,
      name: name
    )
    
    let response: SneakersResponse = try await networkClient.request(endpoint)
    return Mapper.map(from: response.results)
  }
  
  func fetchSneakerID(id: String) async throws -> Sneaker {
    let endpoint = SneakersEndpoint.getSneakerId(id: id)
    let response: SneakersResponse = try await networkClient.request(endpoint)
    
    guard let sneakerDTO = response.results.first else {
      throw NetworkError.custom(description: "Sneaker not found")
    }
    
    return Mapper.map(from: sneakerDTO)
  }
}
