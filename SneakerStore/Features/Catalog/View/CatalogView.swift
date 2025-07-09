import SwiftUI

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
              .onAppear { print(sneakers.count) }
          case .error(let error):
            errorScreen(error)
          case .empty:
            emptyScreen
        }
      }
      .contentMargins(.horizontal, 24, for: .scrollContent)
      .scrollIndicators(.hidden)
      .task {
        await vm.handle(intent: .onAppear)
      }
    }
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
          onLastItemAppear: { Task {await vm.handle(intent: .fetchNextPage)}}
        )
      }
      
      if vm.isFetchingNextPage {
        ProgressView().padding()
      }
    }
  }
  
  private func errorScreen(_ error: Error) -> some View {
    VStack(spacing: 12) {
      Text("Oops! Something went wrong.")
        .font(.system(size: 16, weight: .bold))
      
      Text(error.localizedDescription)
        .font(.system(size: 12))
        .opacity(0.6)
      
      Button("Try Again") {
        Task { await vm.handle(intent: .reloadCatalog) }
      }
      .padding(.top)
    }
    .frame(maxWidth: .infinity, minHeight: 400)
  }
  
  private var emptyScreen: some View {
    Text("No sneakers found.")
      .font(.system(size: 16, weight: .bold))
      .frame(maxWidth: .infinity, minHeight: 400)
  }
}

//MARK: - Preview
#Preview {
  CatalogView()
}
