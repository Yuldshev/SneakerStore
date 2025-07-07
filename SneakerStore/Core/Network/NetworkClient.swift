import Foundation
import Alamofire

protocol NetworkClientProtocol {
  func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
}

final class NetworkClient: NetworkClientProtocol {
  private let decoder: JSONDecoder
  
  init() {
    self.decoder = JSONDecoder()
    self.decoder.keyDecodingStrategy = .convertFromSnakeCase
  }
  
  func request<T>(_ endpoint: APIEndpoint) async throws -> T where T : Decodable {
    do {
      return try await AF.request(endpoint)
        .validate()
        .serializingDecodable(T.self, decoder: decoder)
        .value
    } catch {
      if let afError = error as? AFError {
        throw NetworkError(afError: afError)
      } else {
        throw NetworkError.custom(description: error.localizedDescription)
      }
    }
  }
  
}
