import SwiftUI

struct BrowseView: View {
  @Environment(\.router) var router
  
  var body: some View {
    ZStack {
      Color(.systemGray6).ignoresSafeArea()
      
      ScrollView(.vertical) {
        LazyVStack(spacing: 8) {
          Text("All brands")
            .font(.system(size: 24, weight: .bold))
            .frame(maxWidth: .infinity, minHeight: 80, alignment: .leading)
          
          ListBrands
        }
        .scrollTargetLayout()
      }
      .scrollTargetBehavior(.viewAligned)
      .scrollIndicators(.hidden)
      .contentMargins(.horizontal, 24, for: .scrollContent)
    }
    .toolbar(.hidden, for: .navigationBar)
  }
}

//MARK: - Helper
extension BrowseView {
  private var ListBrands: some View {
    ForEach(SneakerBrand.displayCases, id: \.rawValue) { brand in
      Text(brand.rawValue.capitalized)
        .padding(.leading)
        .frame(maxWidth: .infinity, minHeight: 50, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .containerRelativeFrame(.vertical, count: 12, spacing: 8)
        .scrollTransition { content, phase in
          content
            .opacity(phase.isIdentity ? 1 : 0.4)
            .scaleEffect(phase.isIdentity ? 1 : 0.9)
            .blur(radius: phase.isIdentity ? 0 : 1)
        }
        .onTapGesture {
          router.showScreen(.push) { _ in BrowseDetailView(brand: brand) }
        }
    }
  }
}

//MARK: - Preview
#Preview {
  BrowseView()
    .previewRouter()
}
