import SwiftUI
import SwiftfulRouting

struct CatalogView: View {
  @State private var vm: CatalogVM
  private let router: AnyRouter
  
  init(router: AnyRouter) {
    self.router = router
    self._vm = State(initialValue: VMFactory.makeCatalog(router: router))
  }
  
  var body: some View {
    ZStack {
      Color(.systemGray6).ignoresSafeArea()
      
      ScrollView(.vertical) {
        switch vm.state.catalogState {
          case .idle, .loading:
            skeletonScreen
          case .loaded:
            loadedScreen(vm.sneakerCards)
          case .error(let error):
            errorScreen(error)
          case .empty:
            emptyScreen(header: "No Sneakers Found", icon: "shoeprints.fill", description: "Try changing your filters or come back later."
            )
        }
      }
      .contentMargins(.horizontal, 24, for: .scrollContent)
      .scrollIndicators(.hidden)
      .task {
        if vm.sneakerCards.isEmpty {
          await vm.send(intent: .onAppear)
        }
      }
    }
    .navigationTitle("Sneaker Store")
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
  
  private func loadedScreen(_ models: [SneakerCardModel]) -> some View {
    VStack(spacing: 24) {
      SneakerBanners(
        bannerStates: vm.state.bannerStates,
        onTap: { vm.handleBannerTap($0)}
      )
      
      VStack(alignment: .leading, spacing: 16) {
        Text("Recommended Sneakers")
          .font(.system(size: 24, weight: .bold))
        
        SneakerGrid(models: models)
        .padding(.bottom)
      }
    }
  }
}

