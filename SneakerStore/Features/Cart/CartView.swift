import SwiftUI

struct CartView: View {
  @State private var vm = CartVM()
  
  var body: some View {
    ZStack {
      Color(.systemGray6).ignoresSafeArea()
      
      Group {
        switch vm.state {
          case .idle, .loading:
            ProgressView()
              .frame(maxWidth: .infinity, maxHeight: .infinity)
          case .loaded(let sneakers):
            loaded(sneakers)
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
  private func loaded(_ sneakers: [Sneaker]) -> some View {
    ScrollView(.vertical) {
      VStack(spacing: 12) {
        ForEach(sneakers, id: \.id) { sneaker in
          SneakerListItem(sneaker: sneaker)
            .scrollTransition { content, phase in
              content
                .opacity(phase.isIdentity ? 1 : 0.6)
                .scaleEffect(phase.isIdentity ? 1 : 0.9)
                .blur(radius: phase.isIdentity ? 0 : 2)
            }
            .swipeActions {
              Action(symbolImage: "trash.fill", tint: .white, background: .red) { _ in vm.toggleCart(sneaker) }
            }
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
  CartView()
    .previewRouter()
}
