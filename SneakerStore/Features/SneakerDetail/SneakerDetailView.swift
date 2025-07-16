import SwiftUI

struct SneakerDetailView: View {
  @State private var vm: SneakerDetailVM
  private let sneaker: Sneaker
  
  init(sneaker: Sneaker) {
    self.sneaker = sneaker
    self._vm = State(initialValue: VMFactory.makeDetailVM(sneaker: sneaker))
  }
  
  @State private var selectedIndex = 0
  
  var body: some View {
    ZStack {
      Color(.systemGray6).ignoresSafeArea()
      
      ScrollView(.vertical) {
        VStack(spacing: 16) {
          SneakerImage
          SneakerInfo
          ColorwaySection
        }
        .padding(.horizontal, 24)
      }
      .scrollIndicators(.hidden)
    }
    .navigationTitle("\(sneaker.brand.rawValue.capitalized) \(sneaker.silhouette.capitalized)")
    .animation(.smooth, value: selectedIndex)
  }
}

//MARK: - Helper
extension SneakerDetailView {
  private var SneakerImage: some View {
    LoaderImage(url: sneaker.variants[selectedIndex].image) {
      Rectangle().fill(Color(.systemGray4)).skeleton(true)
    }
      .background(.white)
      .frame(maxWidth: .infinity, minHeight: 280)
      .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
      .transition(.blurReplace)
      .id(selectedIndex)
      .overlay(alignment: .bottomTrailing) {
        VStack {
          ButtonAction(isBool: vm.isFavorite, icon: .favorite, onTap: { vm.onFavoriteTap() })
          ButtonAction(isBool: vm.isCart, icon: .cart, onTap: { vm.onCartTap() })
        }
        .padding(12)
      }
  }
  
  private var SneakerInfo: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text(sneaker.name)
        .font(.system(size: 24, weight: .bold))
        .multilineTextAlignment(.leading)
      
      Text(sneaker.story)
        .font(.system(size: 14))
        .lineSpacing(6)
    }
  }
  
  private var ColorwaySection: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("Color Way")
        .font(.system(size: 18, weight: .semibold))
      
      ScrollView(.horizontal) {
        HStack(spacing: 12) {
          ForEach(Array(sneaker.variants.enumerated()), id: \.element.id) { index, variant in
            Button { selectedIndex = index } label: {
              Text(variant.colorway)
                .font(.system(size: 12))
                .lineLimit(1)
                .foregroundStyle(selectedIndex == index ? .white : .black)
                .padding()
                .background(selectedIndex == index ? .black : .white)
                .clipShape(Capsule())
                .frame(maxWidth: 200)
            }
          }
        }
      }
    }
    .padding(.vertical, 8)
  }
  
  private var ButtonCart: some View {
    Button { vm.onCartTap() } label: {
      HStack(spacing: 18) {
        Image(systemName: vm.isCart ? "cart.fill" : "cart")
          .foregroundColor(vm.isCart ? .white : .black)
          .font(.system(size: 16))
        
        VStack(alignment: .leading, spacing: 4.0) {
          Text(sneaker.price.asCurrency())
            .foregroundColor(vm.isCart ? .white : .black)
            .font(.system(size: 18, weight: .bold))
          
          Text(vm.isCart ? "Added": "Buy")
            .foregroundColor(vm.isCart ? .white : .black)
            .font(.system(size: 14))
        }
      }
      .frame(maxWidth: .infinity, minHeight: 60)
      .background(vm.isCart ? .black : .white)
      .clipShape(Capsule())
    }
    .animation(.easeInOut, value: vm.isCart)
  }
  
  private var ButtonFavorite: some View {
    Button { vm.onFavoriteTap() } label: {
      Image(systemName: vm.isFavorite ? "heart.fill" : "heart")
        .font(.system(size: 20))
        .foregroundColor(vm.isFavorite ? .white : .black)
        .frame(minWidth: 60, minHeight: 60)
        .background(vm.isFavorite ? .black : .white)
        .clipShape(Circle())
    }
    .animation(.easeInOut, value: vm.isFavorite)
  }
}

