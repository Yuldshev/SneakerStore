import SwiftUI

struct FavoritesView: View {
  @State var vm = FavoritesVM()
  
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
            emptyScreen(header: "No favorites yet", icon: "heart.fill", description: "Add sneakers you like to your favorites list")
        }
      }
    }
    .navigationTitle("Favorites")
  }
}

//MARK: - Helper
extension FavoritesView {
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
              Action(symbolImage: "cart", tint: .white, background: .green) { _ in
              }
              
              Action(symbolImage: "trash", tint: .white, background: .red) { _ in
                vm.toggleFavorite(sneaker)
              }
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
  FavoritesView()
    .previewRouter()
}
