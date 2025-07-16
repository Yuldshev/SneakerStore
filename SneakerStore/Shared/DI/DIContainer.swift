import Foundation

@MainActor
final class DIContainer {
  static let shared = DIContainer()
  
  private init() {}
  
  private lazy var networkClient: NetworkClientProtocol = NetworkClient()
  private lazy var cacheService: CacheServiceProtocol = CacheService()
  private lazy var favoriteCollectionService: UserCollectionServiceProtocol = UserCollectionService(cacheService: self.cacheService, cacheKey: "favorite_sneakers")
  private lazy var cartCollectionService: UserCollectionServiceProtocol = UserCollectionService(cacheService: self.cacheService, cacheKey: "cart_sneakers")
  
  lazy var sneakerService: SneakersServiceProtocol = SneakersService(network: networkClient, cache: cacheService)
  lazy var favoriteService: FavoriteServiceProtocol = FavoriteService(collectionService: favoriteCollectionService)
  lazy var cartService: CartServiceProtocol = CartService(collectionService: cartCollectionService)
}
