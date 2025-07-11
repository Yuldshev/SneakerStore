import SwiftUI

struct ProfileView: View {
  @State private var vm = ProfileVM()
  
  var body: some View {
    ZStack {
      Color(.systemGray6).ignoresSafeArea()
      
      VStack {
        
      }
    }
    .navigationTitle("Profile")
  }
}

#Preview {
  ProfileView()
    .previewRouter()
}
