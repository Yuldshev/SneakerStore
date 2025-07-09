import SwiftUI

struct SneakerCart: View {
  var sneaker: Sneaker
  var isFav: Bool = false
  var onTapFavorite: () -> Void = {}
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      LoaderImage(url: sneaker.thumbnail, resizingMode: .fill)
        .padding()
        .frame(height: 180)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
      
      VStack(alignment: .leading, spacing: 4) {
        Text("$\(sneaker.price)")
          .font(.system(size: 16, weight: .bold))
        Text("\(sneaker.brand.rawValue.capitalized) \(sneaker.silhouette)")
          .font(.system(size: 12))
          .lineLimit(2)
          .opacity(0.6)
      }
      .padding(.leading, 8)
    }
    .overlay(alignment: .topTrailing) {
      Button {
        withAnimation(.easeInOut) { onTapFavorite() }
      } label: {
        Image(systemName: isFav ? "heart.fill" : "heart")
          .foregroundStyle(.black)
          .padding(10)
          .background(Color(.systemGray6))
          .clipShape(Circle())
      }
      .padding(12)
    }
  }
}

#Preview {
  let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
  
  ZStack {
    Color(.systemGray6).ignoresSafeArea()
    
    LazyVGrid(columns: columns, spacing: 16) {
      SneakerCart(sneaker: Sneaker.mock.first!, isFav: true)
      SneakerCart(sneaker: Sneaker.mock.first!, isFav: false)
    }
    .padding(.horizontal, 24)
  }
}
