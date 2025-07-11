import Foundation

protocol SneakersServiceProtocol {
  func fetchSneakers(count: Int) async throws -> [Sneaker]
  func fetchSneaker(id: String) async throws -> Sneaker
  func searchSneakers(name: String?, brand: SneakerBrand?, gender: SneakerGender?, sort: String?, count: Int) async throws -> [Sneaker]
}

final class SneakersService: SneakersServiceProtocol {
  //MARK: - Properties
  private var networkClient: NetworkClientProtocol
  private var cacheService: CacheServiceProtocol
  private let apiLimit = 50
  
  init(network: NetworkClientProtocol = NetworkClient(), cache: CacheServiceProtocol = CacheService()) {
    self.networkClient = network
    self.cacheService = cache
  }
  
  //MARK: - Fetch Sneakers
  func fetchSneakers(count: Int) async throws -> [Sneaker] {
    return try await loadSneakersLoop(count: count)
  }
  
  //MARK: - Fetch SneakerID
  func fetchSneaker(id: String) async throws -> Sneaker {
    let cacheKey = "sneaker_\(id)"
    
    if let cached: SneakerDTO = await cacheService.loadCache(key: cacheKey, as: SneakerDTO.self) {
      if let sneaker = Mapper.map(from: [cached]).first { return sneaker }
    }
    
    let endpoint = SneakersEndpoint.getSneakerId(id: id)
    let response: SneakersResponse = try await networkClient.request(endpoint)
    
    guard let sneakerDTO = response.results.first else {
      throw NetworkError.custom(description: "Sneaker not found")
    }
    
    await cacheService.saveCache(sneakerDTO, key: cacheKey)
    
    guard let sneaker = Mapper.map(from: [sneakerDTO]).first else {
      throw NetworkError.custom(description: "Mapping failed")
    }
    
    return sneaker
  }
  
  //MARK: - Search Sneakers
  func searchSneakers(name: String?, brand: SneakerBrand?, gender: SneakerGender?, sort: String?, count: Int) async throws -> [Sneaker] {
    return try await loadSneakersLoop(name: name, brand: brand, gender: gender, sort: sort, count: count)
  }
  
  //MARK: - Private methods
  private func loadSneakersLoop(
    name: String? = nil,
    brand: SneakerBrand? = nil,
    gender: SneakerGender? = nil,
    sort: String? = nil,
    count: Int
  ) async throws -> [Sneaker] {
    var sneakers: [Sneaker] = []
    var currentPage = 1
    
    while sneakers.count < count {
      try await withThrowingTaskGroup(of: [SneakerDTO].self) { group in
        for _ in 0..<5 {
          currentPage += 1
          let page = currentPage
          
          group.addTask {
            let cacheKey = self.makeCacheKey(page: page, name: name, brand: brand, gender: gender, sort: sort)
            
            if let cached: [SneakerDTO] = await self.cacheService.loadCache(key: cacheKey, as: [SneakerDTO].self) {
              return cached
            }
            
            let dtos = try await self.fetchSneakerDTOs(limit: self.apiLimit, page: page, gender: gender, brand: brand, sort: sort, name: name)
            await self.cacheService.saveCache(dtos, key: cacheKey)
            return dtos
          }
          
          try await Task.sleep(for: .seconds(1))
        }
        
        for try await dtos in group {
          if dtos.isEmpty { continue }
          let mappedSneakers = Mapper.map(from: dtos)
          sneakers.append(contentsOf: mappedSneakers)
        }
      }
    }
    return sneakers
  }

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
  
  private func makeCacheKey(page: Int, name: String?, brand: SneakerBrand?, gender: SneakerGender?, sort: String?) -> String {
    [ "sneakers", "page=\(page)", name.map { "name=\($0)" }, brand.map { "brand=\($0)" }, gender.map { "gender=\($0)" }, sort.map { "sort=\($0)" }]
      .compactMap { $0 }
      .joined(separator: "&")
  }
}
