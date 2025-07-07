import Foundation
import Alamofire

enum NetworkError: Error, LocalizedError {
  case invalidURL
  case requestFailed(Error)
  case invalidResponse
  case decodingFailed(Error)
  case custom(description: String)
  
  init(afError: AFError) {
    switch afError {
      case .invalidURL: self = .invalidURL
      case .responseValidationFailed(reason: .unacceptableStatusCode) : self = .invalidResponse
      case .responseSerializationFailed: self = .decodingFailed(afError)
      default: self = .requestFailed(afError)
    }
  }
  
  var errorDescription: String? {
    switch self {
      case .invalidURL: return "Invalid URL"
      case .invalidResponse: return "Invalid response from server"
      case .decodingFailed(let error): return "Decoding failed: \(error.localizedDescription)"
      case .requestFailed(let error): return "Request failed: \(error.localizedDescription)"
      case .custom(description: let description): return description
    }
  }
}
