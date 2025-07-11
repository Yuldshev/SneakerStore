import SwiftUI

struct BrowseDetailView: View {
  @State private var vm: BrowseVM
  
  init(brand: SneakerBrand) {
    _vm = State(initialValue: BrowseVM(brand: brand))
  }
  
  var body: some View {
    ZStack {
      Color(.systemGray6).ignoresSafeArea()
      
      ScrollView(.vertical) {
        LazyVStack(pinnedViews: [.sectionHeaders]) {
          Section {
            switch vm.state {
              case .idle, .loading:
                SkeletonGrid().skeleton(true)
              case .loaded(let sneakers):
                LoadedSneakers(sneakers)
              case .error(let error):
                errorScreen(error)
              case .empty:
                emptyScreen(header: "No Sneakers Found", icon: "shoeprints.fill", description: "Try changing your filters or come back later."
                )
            }
          } header: {
            FilterHeader
          }
        }
      }
      .scrollIndicators(.hidden)
      .contentMargins(.horizontal, 24, for: .scrollContent)
    }
    .navigationTitle(vm.selectedBrand?.rawValue.capitalized ?? "Brand")
    .searchable(text: $vm.query, placement: .navigationBarDrawer(displayMode: .automatic))
    .task { vm.initialLoad() }
  }
}

//MARK: - Helper
extension BrowseDetailView {
  private var FilterHeader: some View {
    HStack {
      Picker("Gender", selection: $vm.selectedGender) {
        Text("All Genders").tag(SneakerGender?.none)
        ForEach(SneakerGender.allCases, id: \.self) { gender in
          Text(gender.rawValue.capitalized).tag(gender)
        }
      }
      .pickerStyle(.menu)
      .onChange(of: vm.selectedGender) { _, _ in
        vm.performSearch()
      }
      
      Spacer()
      
      Menu {
        Button("Price: LH") { vm.selectSort("retailPrice:asc") }
        Button("Price: HL") { vm.selectSort("retailPrice:desc") }
      } label: {
        Label("Sort", systemImage: "arrow.up.arrow.down")
      }
    }
    .tint(.black)
    .padding(.vertical, 8)
    .background(Color(.systemGray6))
  }
  
  private func LoadedSneakers(_ sneakers: [Sneaker]) -> some View {
    SneakerGrid(
      sneakers: sneakers,
      isFavorite: { vm.isFavorite(sneaker: $0) },
      toggleFavorite: { vm.toggleFavorite(sneaker: $0) },
      isCart: { vm.isCart(sneaker: $0) },
      toggleCart: { vm.addCart(sneaker: $0) }
    )
  }
}

//MARK: - Preview
#Preview {
  BrowseDetailView(brand: .jordan)
    .previewRouter()
}
