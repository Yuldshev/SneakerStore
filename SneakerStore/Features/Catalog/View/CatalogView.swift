import SwiftUI

struct CatalogView: View {
  @State private var vm = CatalogVM()
  
  var body: some View {
    ZStack {
      Color(.systemGray6).ignoresSafeArea()
      
      ScrollView(.vertical) {
        switch vm.state.catalogState {
          case .idle, .loading:
            ProgressView()
              .frame(maxWidth: .infinity, minHeight: 400)
          case .loaded(let sneakers):
            LoadedScreen(sneakers)
          case .error(let error):
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
          case .empty:
            Text("No sneakers found.")
              .font(.system(size: 16, weight: .bold))
              .frame(maxWidth: .infinity, minHeight: 400)
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

//MARK: - Helper view
extension CatalogView {
  private func LoadedScreen(_ sneakers: [Sneaker]) -> some View {
    VStack(spacing: 24) {
      SneakerBanners(bannerStates: vm.state.bannerStates)
      SneakerGrid(sneakers: sneakers)
    }
  }
}

//MARK: - Preview
#Preview {
  CatalogView()
}
