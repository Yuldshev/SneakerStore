import Foundation

struct AuthState {
  var email = ""
  var pass = ""
  var isLoading = false
  var errorMessage: String?
}

enum AuthIntent {
  case emailChanged(String)
  case passChanged(String)
  case login
}
