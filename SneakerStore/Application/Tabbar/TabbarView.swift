import SwiftUI
import SwiftfulRouting

struct TabbarView: View {
  @State private var vm = VMFactory.makeTab()
  
  var body: some View {
    TabView {
      Tab("Home", systemImage: "house.fill") {
        RouterView(addNavigationStack: true, addModuleSupport: false) { router in
          CatalogView(router: router)
        }
      }
      
      Tab("Browse", systemImage: "magnifyingglass") {
        RouterView(addNavigationStack: true, addModuleSupport: false) { _ in
          BrowseView()
        }
      }
      
      Tab("Favorites", systemImage: "heart.fill") {
        RouterView(addNavigationStack: true, addModuleSupport: false) { router in
          FavoritesView(router: router)
        }
      }
      
      Tab("Cart", systemImage: "cart.fill") {
        RouterView(addNavigationStack: true, addModuleSupport: false) { router in
          CartView(router: router)
        }
      }
      .badge(vm.cartCount)
    }
  }
}

//MARK: - Preview
#Preview {
  TabbarView()
}
