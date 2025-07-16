import SwiftUI

struct BrowseView: View {
  @Environment(\.router) var router
  
  var body: some View {
    ZStack {
      Color(.systemGray6).ignoresSafeArea()
      
      List(SneakerBrand.displayCases, id: \.rawValue) { brand in
        Button {
          router.showScreen(.push) { router in
            BrowseDetailView(brand: brand, router: router)
          }
        } label: {
          Text(brand.rawValue.capitalized)
            .font(.system(size: 16))
            .foregroundStyle(.black)
        }
      }
      .scrollIndicators(.hidden)
    }
    .navigationTitle("All Brands")
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
          
        }
    }
  }
}

//MARK: - Preview
#Preview {
  BrowseView()
    .previewRouter()
}
