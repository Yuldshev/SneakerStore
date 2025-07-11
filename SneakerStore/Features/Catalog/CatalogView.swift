import SwiftUI
import SwiftfulRouting

struct CatalogView: View {
  @State private var vm = CatalogVM()
  
  var body: some View {
    ZStack {
      Color(.systemGray6).ignoresSafeArea()
      
      ScrollView(.vertical) {
        switch vm.state.catalogState {
          case .idle, .loading:
            skeletonScreen
          case .loaded(let sneakers):
            loadedScreen(sneakers)
          case .error(let error):
            errorScreen(error)
          case .empty:
            emptyScreen(header: "No Sneakers Found", icon: "shoeprints.fill", description: "Try changing your filters or come back later."
            )
        }
      }
      .contentMargins(.horizontal, 24, for: .scrollContent)
      .scrollIndicators(.hidden)
      .task { await vm.send(intent: .onAppear) }
    }
    .navigationTitle("Welcome User")
  }
}

//MARK: - Helper
extension CatalogView {
  private var skeletonScreen: some View {
    VStack {
      Rectangle()
        .frame(maxWidth: .infinity, minHeight: 170, alignment: .top)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .foregroundStyle(Color(.systemGray4))
        .padding(.vertical)
        .padding(.bottom, 20)
      
      SkeletonGrid()
    }
  .skeleton(true)
    
  }
  
  private func loadedScreen(_ sneakers: [Sneaker]) -> some View {
    VStack(spacing: 24) {
      SneakerBanners(state: vm.state.bannerStates)
      
      VStack(alignment: .leading, spacing: 16) {
        Text("Recommended Sneakers")
          .font(.system(size: 24, weight: .bold))
        
        SneakerGrid(
          sneakers: sneakers,
          isFavorite: { vm.isFavorite(sneaker: $0) },
          toggleFavorite: { vm.toggleFavorite(sneaker: $0) },
          isCart: { vm.isCart(sneaker: $0) },
          toggleCart: { vm.addToCart(sneaker: $0) }
        )
        .padding(.bottom)
      }
    }
  }
}

//MARK: - Preview
#Preview {
  CatalogView()
    .previewRouter()
}
