import Foundation
import SwiftfulRouting

protocol RouterProtocol {
  func showSneakerDetail(model: SneakerCardModel) async
}

@Observable
final class Router: RouterProtocol {
  let router: AnyRouter
  
  init(router: AnyRouter) {
    self.router = router
  }
  
  @MainActor
  func showSneakerDetail(model: SneakerCardModel) async {
    router.showScreen(.push) { _ in
      SneakerDetail(sneaker: model.sneaker)
    }
  }
}
