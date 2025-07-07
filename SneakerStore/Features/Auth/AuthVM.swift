import Foundation

@Observable
final class AuthVM {
  private(set) var state = AuthState()
  
  private let service: AuthServiceProtocol
  
  init(service: AuthServiceProtocol = AuthService()) {
    self.service = service
  }
  
  @MainActor
  func send(intent: AuthIntent) {
    switch intent {
      case .emailChanged(let email): state.email = email
      case .passChanged(let pass): state.pass = pass
      case .login:
        Task {
          state.isLoading = true
          state.errorMessage = nil
          
          do {
            _ = try await service.signIn(email: state.email, pass: state.pass)
          } catch {
            state.errorMessage = error.localizedDescription
          }
          state.isLoading = false
        }
    }
  }
}
