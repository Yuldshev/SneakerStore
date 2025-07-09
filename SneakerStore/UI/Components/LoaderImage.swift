import SwiftUI
import Kingfisher

struct LoaderImage: View {
  var url: URL = (Sneaker.mock.first?.thumbnail)!
  var resizingMode: SwiftUI.ContentMode = .fit
  var placeholder: Color = Color(.systemGray4)
  
  var body: some View {
    Rectangle()
      .opacity(0.01)
      .overlay {
        KFImage(url)
          .placeholder {
            ZStack {
              placeholder
                .skeleton(true)
            }
          }
          .resizable()
          .aspectRatio(contentMode: resizingMode)
          
      }
      .clipped()
  }
}

#Preview {
  ZStack {
    Color(.systemGray6).ignoresSafeArea()
    
    LoaderImage()
      .padding(50)
  }
}
