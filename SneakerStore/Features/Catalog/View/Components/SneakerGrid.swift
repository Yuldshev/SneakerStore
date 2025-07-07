import SwiftUI

struct SneakerGrid: View {
  let sneakers: [Sneaker]
  
  private let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Recommended Sneakers")
        .font(.system(size: 24, weight: .bold))
      
      LazyVGrid(columns: columns, spacing: 16) {
        ForEach(sneakers, id: \.id) { sneaker in
          SneakerCart(sneaker: sneaker)
        }
      }
    }
  }
}

