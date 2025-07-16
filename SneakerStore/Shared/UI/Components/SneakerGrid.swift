import SwiftUI

struct SneakerGrid: View {
  var models: [SneakerCardModel]
  
  @Environment(\.router) var router
  
  private let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
  
  var body: some View {
    LazyVGrid(columns: columns, spacing: 16) {
      ForEach(models, id: \.id) { model in
        Button {
          router.showScreen(.push) { _ in
            SneakerDetailView(sneaker: model.sneaker)
          }
        } label: {
          SneakerCard(model: model)
            .id("\(model.id)-\(model.isFavorite)-\(model.isCart)")
        }
      }
    }
  }
}




