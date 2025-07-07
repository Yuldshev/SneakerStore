import SwiftUI

struct AuthView: View {
  @State var vm = AuthVM()
  
  var body: some View {
    VStack(spacing: 20) {
      TextField("Email", text: Binding(
        get: { vm.state.email },
        set: { vm.send(intent: .emailChanged($0)) }
      ))
      .keyboardType(.emailAddress)
      
      SecureField("Password", text: Binding(
        get: { vm.state.pass },
        set: { vm.send(intent: .passChanged($0)) }
      ))
      
      if let error = vm.state.errorMessage {
        Text(error).foregroundColor(.red)
      }
      
      Button { vm.send(intent: .login)} label: {
        if vm.state.isLoading {
          ProgressView()
        } else {
          Text("Sign In")
        }
      }
    }
  }
}

#Preview {
  AuthView()
}
