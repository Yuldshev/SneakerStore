import SwiftUI

extension View {
  func errorScreen(_ error: Error) -> some View {
    ContentUnavailableView {
      Label("Something went wrong", systemImage: "exclamationmark.triangle.fill")
    } description: {
      Text(error.localizedDescription)
    }
  }
  
  func emptyScreen(header: String, icon: String, description: String) -> some View {
    ContentUnavailableView {
      Label(header, systemImage: icon)
    } description: {
      Text(description)
    }
  }
}


