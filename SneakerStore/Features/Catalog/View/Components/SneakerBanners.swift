import SwiftUI
import Kingfisher

struct SneakerBanners: View {
  let bannerStates: [LoadingState<Sneaker>]
  @State private var currentIndex = 0
  
  private var loadedBanners: [Sneaker] {
    bannerStates.compactMap { state in
      if case .loaded(let sneaker) = state {
        return sneaker
      }
      return nil
    }
  }
  
  var body: some View {
    VStack {
      if loadedBanners.isEmpty {
        Rectangle()
          .fill(.white)
          .aspectRatio(16/9 ,contentMode: .fit)
          .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
          .overlay(ProgressView())
      } else {
        TabView(selection: $currentIndex) {
          ForEach(loadedBanners.indices, id: \.self) { index in
            BannerView(sneaker: loadedBanners[index])
              .tag(index)
          }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 200)
      }
      
      HStack(spacing: 4) {
        ForEach(loadedBanners.indices, id: \.self) { index in
            Rectangle()
            .fill(currentIndex == index ? .black : .black.opacity(0.4))
            .frame(width: currentIndex == index ? 24 : 8, height: 4)
            .clipShape(Capsule())
        }
      }
      .animation(.easeInOut, value: currentIndex)
    }
  }
}

//MARK: - BannerView
private struct BannerView: View {
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
      
      KFImage(sneaker.thumbnail)
        .resizable()
        .scaledToFit()
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

#Preview {
  BannerView(sneaker: mockSneaker.first!!)
    .padding(.horizontal, 24)
}
