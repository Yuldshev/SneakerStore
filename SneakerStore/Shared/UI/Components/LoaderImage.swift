import SwiftUI
import Kingfisher

struct LoaderImage<Placeholder: View>: View {
  var url: URL = (Sneaker.mock.first?.thumbnail)!
  var resizingMode: SwiftUI.ContentMode = .fit
  var placeholder: () -> Placeholder
  
  @State private var isLoaded = false
  
  var body: some View {
    ZStack {
      if !isLoaded {
        placeholder()
      }
      
      KFImage(url)
        .onSuccess { _ in
          withAnimation(.easeInOut(duration: 0.3)) {
            isLoaded = true
          }
        }
        .resizable()
        .aspectRatio(contentMode: resizingMode)
        .opacity(isLoaded ? 1 : 0)
    }
    .clipped()
  }
}
