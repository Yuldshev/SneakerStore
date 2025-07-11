import SwiftUI
import SwiftfulRouting

extension View {
  func previewRouter() -> some View {
    RouterView { _ in
      self
    }
  }
}
