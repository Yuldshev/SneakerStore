import SwiftUI

struct FavoritesView: View {
  @State var vm = FavoritesVM()
  
  var body: some View {
    ZStack {
      Color(.systemGray6).ignoresSafeArea()
      
      ScrollView(.vertical) {
        VStack(spacing: 0) {
          ForEach(vm.sneakers, id: \.id) { sneaker in
            FavoriteCard(sneaker: sneaker)
              .containerRelativeFrame(.vertical, count: 6, spacing: 4)
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
        .padding(.horizontal, 24)
        .scrollTargetLayout()
      }
      .scrollTargetBehavior(.viewAligned)
      .scrollIndicators(.hidden)
    }
    .navigationTitle("Favorites")
  }
}

#Preview {
  FavoritesView()
    .previewRouter()
}
