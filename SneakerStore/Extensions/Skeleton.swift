import SwiftUI

extension View {
  func skeleton(_ isRedacted: Bool) -> some View {
    self
      .modifier(SkeletonModifier(isRedacted: isRedacted))
  }
}

struct SkeletonModifier: ViewModifier {
  var isRedacted: Bool
  @State private var isAnimation = false
  @Environment(\.colorScheme) private var scheme
  
  var rotation: Double {
    return 5
  }

  var animation: Animation {
    .easeInOut(duration: 1.5).repeatForever(autoreverses: false)
  }

  func body(content: Content) -> some View {
    content
      .redacted(reason: isRedacted ? .placeholder : [])
    
      .overlay {
        if isRedacted {
          GeometryReader {
            let size = $0.size
            let skeletonWidth = size.width / 2
            let blurRadius = max(skeletonWidth / 2, 30)
            let blurDiameter = blurRadius * 2
            let minX = -(skeletonWidth + blurDiameter)
            let maxX = size.width + skeletonWidth + blurDiameter
            
            Rectangle()
              .fill(scheme == .dark ? .white : .black)
              .frame(width: skeletonWidth, height: size.height * 2)
              .frame(height: size.height)
              .blur(radius: blurRadius)
              .rotationEffect(.init(degrees: rotation))
              .offset(x: isAnimation ? maxX : minX)
          }
          .mask {
            content
              .redacted(reason: .placeholder)
          }
          .blendMode(.softLight)
          .task {
            guard !isAnimation else { return }
            withAnimation(animation) { isAnimation = true }
          }
          .onDisappear {
            isAnimation = false
          }
          .transaction {
            if $0.animation != animation {
              $0.animation = .none
            }
          }
        }
      }
  }
}
