import Foundation
import Alamofire

protocol APIEndpoint: URLRequestConvertible {
  var baseUrl: URL { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var headers: HTTPHeaders? { get }
  var parameters: [URLQueryItem]? { get }
  var body: Data? { get }
}

extension APIEndpoint {
  var baseUrl: URL {
    guard let url = URL(string: "https://the-sneaker-database.p.rapidapi.com") else {
      fatalError("Invalid base URL")
    }
    return url
  }
  
  var headers: HTTPHeaders? {
    return [
      "x-rapidapi-host": "the-sneaker-database.p.rapidapi.com",
      "x-rapidapi-key": "0641f9141amsh344aaa53f55ca34p162efdjsnf1d05daf4ad3"
      ]
  }
  
  var method: HTTPMethod { .get }
  var parameters: [URLQueryItem]? { nil }
  var body: Data? { nil }
  
  func asURLRequest() throws -> URLRequest {
    var urlComponents = URLComponents(url: baseUrl.appendingPathComponent(path), resolvingAgainstBaseURL: true)
    urlComponents?.queryItems = parameters
    
    guard let url = urlComponents?.url else {
      throw AFError.invalidURL(url: urlComponents?.url ?? baseUrl)
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    request.allHTTPHeaderFields = headers?.dictionary
    request.httpBody = body
    
    return request
  }
}

enum SneakersEndpoint {
  case getSneakers(
    limit: Int,
    page: Int,
    gender: String?,
    brand: String?,
    sort: String?,
    silhouette: String?,
    name: String?
  )
  case getSneakerId(id: String)
}

extension SneakersEndpoint: APIEndpoint {
  var path: String {
    switch self {
      case .getSneakers: return "/sneakers"
      case .getSneakerId(let id): return "/sneakers/\(id)"
    }
  }
  
  var parameters: [URLQueryItem]? {
    switch self {
      case .getSneakers(let limit, let page, let gender, let brand, let sort, let silhouette, let name):
        var queryItems = [
          URLQueryItem(name: "limit", value: "\(limit)"),
          URLQueryItem(name: "page", value: "\(page)")
        ]
        
        if let gender = gender { queryItems.append(URLQueryItem(name: "gender", value: gender))}
        if let brand = brand { queryItems.append(URLQueryItem(name: "brand", value: brand))}
        if let sort = sort { queryItems.append(URLQueryItem(name: "sort", value: sort))}
        if let silhouette = silhouette { queryItems.append(URLQueryItem(name: "silhouette", value: silhouette))}
        if let name = name { queryItems.append(URLQueryItem(name: "name", value: name))}
        
        return queryItems
        
      case .getSneakerId: return nil
    }
  }
}
