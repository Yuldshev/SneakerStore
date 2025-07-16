import SwiftUI

struct SneakerBanners: View {
  let bannerStates: [LoadingState<Sneaker>]
  let onTap: (Sneaker) async -> Void
  
  @State private var currentIndex = 0
  @Environment(\.router) var router
  
  private var timeInterval: TimeInterval = 6.0
  
  private var loadedBanners: [Sneaker] {
    bannerStates.compactMap { state in
      if case .loaded(let sneaker) = state {
        return sneaker
      }
      return nil
    }
  }
  
  init(bannerStates: [LoadingState<Sneaker>], onTap: @escaping (Sneaker) async -> Void) {
    self.bannerStates = bannerStates
    self.onTap = onTap
  }
  
  var body: some View {
    VStack {
      if loadedBanners.isEmpty {
        SkeletonView
      } else {
        TabView(selection: $currentIndex) {
          ForEach(loadedBanners.indices, id: \.self) { index in
            BannerView(sneaker: loadedBanners[index])
              .tag(index)
              .onTapGesture { Task { await onTap(loadedBanners[index])} }
          }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 200)
        .task { await startTimer() }
      }
      
      Indicator
    }
  }
}

//MARK: - Helper
extension SneakerBanners {
  private var SkeletonView: some View {
    Rectangle()
      .fill(.white)
      .aspectRatio(16/9 ,contentMode: .fit)
      .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
      .overlay(ProgressView())
  }
  
  private var Indicator: some View {
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
  
  private func startTimer() async {
    guard !loadedBanners.isEmpty else { return }
    
    while !Task.isCancelled {
      try? await Task.sleep(for: .seconds(timeInterval))
      
      withAnimation(.easeInOut) {
        currentIndex = (currentIndex + 1) % loadedBanners.count
      }
    }
  }
}

