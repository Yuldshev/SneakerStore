import SwiftUI

struct BannerView: View {
  let sneaker: Sneaker
  
  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        Text(sneaker.brand.rawValue.capitalized)
          .font(.system(size: 12))
          .opacity(0.6)
        
        Text(sneaker.silhouette)
          .font(.system(size: 18, weight: .bold))
          .lineLimit(2)
          .frame(width: 110, alignment: .leading)
      }
      .padding(.leading, 24)
      
      Spacer()
      
      LoaderImage(url: sneaker.thumbnail)
        .scaleEffect(1.3)
        .rotationEffect(Angle(degrees: 24))
      
    }
    .padding(.horizontal, 12)
    .frame(height: 170)
    .frame(maxWidth: .infinity)
    .background(.white)
    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    .clipped()
  }
}
