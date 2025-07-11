import Foundation

protocol CacheServiceProtocol {
  func saveCache<T: Encodable>(_ data: T, key: String) async
  func loadCache<T: Decodable>(key: String, as type: T.Type) async -> T?
  func removeCache(for key: String) async
  func clearAllCache() async
}

actor CacheService: CacheServiceProtocol {
  private let userDefaults = UserDefaults.standard
  
  func saveCache<T>(_ data: T, key: String) async where T : Encodable {
    do {
      let encoded = try JSONEncoder().encode(data)
      self.userDefaults.set(encoded, forKey: key)
    } catch {
      return
    }
  }
  
  func loadCache<T>(key: String, as type: T.Type) async -> T? where T : Decodable {
    guard let data = userDefaults.data(forKey: key) else { return nil }
    
    do {
      return try JSONDecoder().decode(T.self, from: data)
    } catch {
      return nil
    }
  }
  
  func removeCache(for key: String) async {
    userDefaults.removeObject(forKey: key)
  }
  
  func clearAllCache() async {
    userDefaults.dictionaryRepresentation().keys
      .forEach { userDefaults.removeObject(forKey: $0) }
  }
}
