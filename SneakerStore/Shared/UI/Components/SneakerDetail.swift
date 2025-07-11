import SwiftUI

struct SneakerDetail: View {
  var sneaker: Sneaker
  
  // Favorite button
  var isFavorite: Bool
  var onFavoriteTapped: () -> Void
  var isCart: Bool
  var onCartTapped: () -> Void
  
  @State private var selectedIndex = 0
  
  var body: some View {
    ZStack {
      Color(.systemGray6).ignoresSafeArea()
      
      ScrollView(.vertical) {
        VStack(spacing: 16) {
          SneakerImage
          SneakerInfo
          ColorwaySection
        }
        .padding(.horizontal, 24)
      }
      .scrollIndicators(.hidden)
    }
    .animation(.smooth, value: selectedIndex)
    .overlay(alignment: .bottom) {
      HStack {
        ButtonFavorite
        ButtonCart
      }.padding(.horizontal, 24)
    }
  }
}

//MARK: - Helper
extension SneakerDetail {
  private var SneakerImage: some View {
    LoaderImage(url: sneaker.variants[selectedIndex].image)
      .background(.white)
      .frame(maxWidth: .infinity, minHeight: 260)
      .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
      .transition(.blurReplace)
      .id(selectedIndex)
  }
  
  private var SneakerInfo: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(sneaker.name)
        .font(.system(size: 24, weight: .bold))
        .multilineTextAlignment(.leading)
      
      Text(sneaker.story)
        .font(.system(size: 14))
    }
  }
  
  private var ColorwaySection: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("Color Way")
        .font(.system(size: 18, weight: .semibold))
      
      ScrollView(.horizontal) {
        HStack(spacing: 12) {
          ForEach(Array(sneaker.variants.enumerated()), id: \.element.id) { index, variant in
            Button { selectedIndex = index } label: {
              Text(variant.colorway)
                .font(.system(size: 12))
                .lineLimit(1)
                .foregroundStyle(selectedIndex == index ? .white : .black)
                .padding()
                .background(selectedIndex == index ? .black : .white)
                .clipShape(Capsule())
                .frame(maxWidth: 200)
            }
          }
        }
      }
    }
  }
  
  private var ButtonCart: some View {
    Button { onCartTapped() } label: {
      HStack(spacing: 18) {
        Image(systemName: isCart ? "cart.fill" : "cart")
          .foregroundColor(isCart ? .white : .black)
          .font(.system(size: 16))
        
        VStack(alignment: .leading, spacing: 4.0) {
          Text(sneaker.price.asCurrency())
            .foregroundColor(isCart ? .white : .black)
            .font(.system(size: 18, weight: .bold))
          
          Text(isCart ? "Added": "Buy")
            .foregroundColor(isCart ? .white : .black)
            .font(.system(size: 14))
        }
      }
      .frame(maxWidth: .infinity, minHeight: 60)
      .background(isCart ? .black : .white)
      .clipShape(Capsule())
    }
    .animation(.easeInOut, value: isCart)
  }
  
  private var ButtonFavorite: some View {
    Button { onFavoriteTapped() } label: {
      Image(systemName: isFavorite ? "heart.fill" : "heart")
        .font(.system(size: 20))
        .foregroundColor(isFavorite ? .white : .black)
        .frame(minWidth: 60, minHeight: 60)
        .background(isFavorite ? .black : .white)
        .clipShape(Circle())
    }
    .animation(.easeInOut, value: isFavorite)
  }
}
