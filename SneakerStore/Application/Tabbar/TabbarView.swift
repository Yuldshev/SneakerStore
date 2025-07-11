import SwiftUI
import SwiftfulRouting

struct TabbarView: View {
  @State private var vm = TabbarVM()
  
  var body: some View {
    TabView {
      Tab("Home", systemImage: "house.fill") {
        RouterView(addNavigationStack: true, addModuleSupport: false) { _ in
          CatalogView()
        }
      }
      
      Tab("Browse", systemImage: "magnifyingglass") {
        RouterView(addNavigationStack: true, addModuleSupport: false) { _ in
          BrowseView()
        }
      }
      
      Tab("Favorites", systemImage: "heart.fill") {
        RouterView(addNavigationStack: true, addModuleSupport: false) { _ in
          FavoritesView()
        }
      }
      
      Tab("Cart", systemImage: "cart.fill") {
        RouterView(addNavigationStack: true, addModuleSupport: false) { _ in
          CartView()
        }
      }
      .badge(vm.cartCount)
      
      Tab("Profile", systemImage: "person.fill") {
        RouterView(addNavigationStack: true, addModuleSupport: false) { _ in
          ProfileView()
        }
      }
    }
  }
}



#Preview {
  TabbarView()
}
