import Foundation

enum LoadingState<T> {
  case idle
  case loading
  case loaded(T)
  case error(Error)
  case empty
}
