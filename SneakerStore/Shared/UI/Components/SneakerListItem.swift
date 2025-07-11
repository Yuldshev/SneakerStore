import SwiftUI

struct SneakerListItem: View {
  var sneaker: Sneaker
  
  var body: some View {
    HStack(spacing: 24) {
      LoaderImage(url: sneaker.thumbnail, resizingMode: .fill)
        .scaleEffect(1.2)
        .frame(width: 80, height: 80)
      
      VStack(alignment: .leading, spacing: 4) {
        Text("$\(sneaker.price)")
          .font(.system(size: 16, weight: .bold))
        
        Text("\(sneaker.brand.rawValue.capitalized) \(sneaker.silhouette)")
          .font(.system(size: 14))
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(.leading, 24)
    .frame(maxWidth: .infinity, minHeight: 80)
    .background(.white)
    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
  }
}
