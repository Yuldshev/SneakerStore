import SwiftUI
import SwiftfulRouting

struct CartView: View {
  @State private var vm: CartVM
  private let router: AnyRouter
  
  init(router: AnyRouter) {
    self.router = router
    self._vm = State(initialValue: VMFactory.makeCart(router: router))
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
            emptyScreen(header: "Nothing here yet", icon: "cart.fill", description: "Looks like your cart is waiting for something special.")
        }
      }
    }
    .navigationTitle("Cart")
  }
}

//MARK: - Helper
extension CartView {
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
              Action(symbolImage: "heart.fill", tint: .white, background: .green) { _ in
                model.onFavoriteTap()
              }
              Action(symbolImage: "trash.fill", tint: .white, background: .red) { _ in
                model.onCartTap()
              }
            }
            .onTapGesture {
              model.onCardTap()
            }
            .id("\(model.id)-\(model.isFavorite)")
        }
      }
      .padding(24)
      .scrollTargetLayout()
    }
    .scrollTargetBehavior(.viewAligned)
    .scrollIndicators(.hidden)
  }
}

