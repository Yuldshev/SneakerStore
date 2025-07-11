import SwiftUI

struct SkeletonGrid: View {
  private let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
  
  var body: some View {
    LazyVGrid(columns: columns, spacing: 16) {
      ForEach(0...5, id: \.self) { _ in
        VStack(alignment: .leading, spacing: 8) {
          Rectangle()
            .foregroundStyle(Color(.systemGray4))
            .frame(height: 180)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
          
          VStack(alignment: .leading, spacing: 4) {
            Text("$100")
              .font(.system(size: 16, weight: .bold))
            Text("Jordan 1 Retro High OG")
              .font(.system(size: 12))
              .lineLimit(2)
              .opacity(0.6)
          }
          .padding(.leading, 8)
        }
      }
    }
  }
}

#Preview {
  SkeletonGrid()
}
