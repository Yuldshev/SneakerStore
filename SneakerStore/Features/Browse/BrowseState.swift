import Foundation

struct BrowseState {
  var sneakers: [Sneaker] = []
  var loadingState: LoadingState<[Sneaker]> = .idle
  var error: String? = nil
}

enum BrowseIntent {
  case onAppear
  case reload
}
