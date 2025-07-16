import Foundation

struct SneakersResponse: Codable {
  let count: Int?
  let results: [SneakersDTO]
}

// MARK: - Result
struct SneakersDTO: Codable, Identifiable {
  let id: String
  let brand, colorway: String
  let estimatedMarketValue: Int?
  let gender: String
  let image: ImageDTO
  let links: LinksDTO?
  let name: String
  let releaseDate, releaseYear: String
  let retailPrice: Int
  let silhouette, sku, story: String?
}

// MARK: - Image
struct ImageDTO: Codable {
  let the360: [String]?
  let original, small, thumbnail: String
}

// MARK: - Links
struct LinksDTO: Codable {
  let stockX: String
  let goat: String
  let flightClub, stadiumGoods: String
}
