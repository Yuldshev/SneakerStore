import Foundation
import FirebaseAuth

protocol AuthServiceProtocol {
  func signIn(email: String, pass: String) async throws -> AuthDataResult
}

final class AuthService: AuthServiceProtocol {
  func signIn(email: String, pass: String) async throws -> AuthDataResult {
    return try await Auth.auth().signIn(withEmail: email, password: pass)
  }
}

