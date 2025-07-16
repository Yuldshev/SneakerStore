import SwiftUI
import SwiftfulRouting

struct FavoritesView: View {
  @State private var vm: FavoritesVM
  private let router: AnyRouter
  
  init(router: AnyRouter) {
    self.router = router
    self._vm = State(initialValue: VMFactory.makeFavorite(router: router))
  }
  
  var body: some View {
    ZStack {
      Color(.systemGray6).ignoresSafeArea()
      
      Group {
        switch vm.state {
          case .idle, .loading:
            ProgressView()
              .frame(maxWidth: .infinity, maxHeight: .infinity)
          case .loaded(let models):
            loaded(models)
          case .error(let error):
            errorScreen(error)
          case .empty:
            emptyScreen(header: "No favorites yet", icon: "heart.fill", description: "Add sneakers you like to your favorites list")
        }
      }
    }
    .navigationTitle("Favorites")
  }
}

//MARK: - Helper
extension FavoritesView {
  private func loaded(_ models: [SneakerCardModel]) -> some View {
    ScrollView(.vertical) {
      VStack(spacing: 12) {
        ForEach(models, id: \.id) { model in
          SneakerListItem(sneaker: model.sneaker)
            .scrollTransition { content, phase in
              content
                .opacity(phase.isIdentity ? 1 : 0.6)
                .scaleEffect(phase.isIdentity ? 1 : 0.9)
                .blur(radius: phase.isIdentity ? 0 : 2)
            }
            .swipeActions {
              Action(symbolImage: "cart", tint: .white, background: .green) { _ in
                model.onCartTap()
              }
              
              Action(symbolImage: "trash", tint: .white, background: .red) { _ in
                model.onFavoriteTap()
              }
            }
            .onTapGesture {
              model.onCardTap()
            }
            .id("\(model.id)-\(model.isCart)")
        }
      }
      .padding(24)
      .scrollTargetLayout()
    }
    .scrollTargetBehavior(.viewAligned)
    .scrollIndicators(.hidden)
  }
}

//MARK: - Preview
#Preview {
  RouterView { router in
    FavoritesView(router: router)
  }
}
