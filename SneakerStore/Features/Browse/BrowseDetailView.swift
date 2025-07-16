import SwiftUI
import SwiftfulRouting

struct BrowseDetailView: View {
  @State private var vm: BrowseVM
  private let brand: SneakerBrand
  private let router: AnyRouter
  
  init(brand: SneakerBrand, router: AnyRouter) {
    self.brand = brand
    self.router = router
    self._vm = State(initialValue: VMFactory.makeBrowse(brand: brand, router: router))
  }
  
  var body: some View {
    ZStack {
      Color(.systemGray6).ignoresSafeArea()
      
      ScrollView(.vertical) {
        LazyVStack(pinnedViews: [.sectionHeaders]) {
          Section {
            switch vm.state.loadingState {
              case .idle, .loading:
                SkeletonGrid().skeleton(true)
              case .loaded:
                LoadedSneakers(vm.sneakerCards)
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
    .task {
      if vm.sneakerCards.isEmpty {
        await vm.send(intent: .reload)
      }
    }
  }
}

//MARK: - Helper
extension BrowseDetailView {
  private var FilterHeader: some View {
    HStack {
      Picker("Gender", selection: $vm.selectedGender) {
        ForEach(SneakerGender.allCases, id: \.self) { gender in
          Text(gender.rawValue.capitalized).tag(gender)
        }
      }
      .pickerStyle(.palette)
      
      Spacer()
      
      Menu {
        Button("Price: LH") { vm.selectedSort = "retailPrice:asc" }
        Button("Price: HL") { vm.selectedSort = "retailPrice:desc" }
      } label: {
        Label("Sort", systemImage: "arrow.up.arrow.down")
      }
    }
    .tint(.black)
    .padding(.vertical, 8)
    .background(Color(.systemGray6))
  }
  
  private func LoadedSneakers(_ models: [SneakerCardModel]) -> some View {
    SneakerGrid(models: models)
  }
}
