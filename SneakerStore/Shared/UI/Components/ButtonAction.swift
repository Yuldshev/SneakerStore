import SwiftUI

struct ButtonAction: View {
  var isBool = true
  var icon: ButtonCategory = .favorite
  var onTap: () -> Void = {}
  
  var body: some View {
    Button {
      withAnimation(.easeInOut) { onTap() }
    } label: {
      Image(systemName: isBool ? icon.iconFill : icon.baseIcon)
        .foregroundStyle(.black)
        .padding(10)
        .background(Color(.systemGray6))
        .clipShape(Circle())
    }
  }
}

enum ButtonCategory {
  case favorite, cart
  
  var baseIcon: String {
    switch self {
      case .favorite: return "heart"
      case .cart: return "cart"
    }
  }
  
  var iconFill: String { "\(baseIcon).fill" }
}

#Preview {
  ButtonAction()
}
