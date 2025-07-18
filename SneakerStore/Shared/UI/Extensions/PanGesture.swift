import SwiftUI

struct PanGestureValue {
  var translation: CGSize = .zero
  var velocity: CGSize = .zero
}

@available(iOS 18, *)
struct PanGesture: UIGestureRecognizerRepresentable {
  var onBegan: () -> ()
  var onChanged: (PanGestureValue) -> ()
  var onEnded: (PanGestureValue) -> ()
  
  
  func makeCoordinator(converter: CoordinateSpaceConverter) -> Coordinator {
    Coordinator()
  }
  func makeUIGestureRecognizer(context: Context) -> UIPanGestureRecognizer {
    let gesture = UIPanGestureRecognizer()
    gesture.delegate = context.coordinator
    return gesture
  }
  
  func updateUIGestureRecognizer(_ recognizer: UIPanGestureRecognizer, context: Context) {
    
  }
  
  func handleUIGestureRecognizerAction(_ recognizer: UIPanGestureRecognizer, context: Context) {
    let state = recognizer.state
    let translation = recognizer.translation(in: recognizer.view).toSize
    let velocity = recognizer.velocity(in: recognizer.view).toSize
    
    let gestureValue = PanGestureValue(translation: translation, velocity: velocity)
    
    switch state {
      case .began: onBegan()
      case .changed: onChanged(gestureValue)
      case .ended, .cancelled: onEnded(gestureValue)
      default: break
    }
  }
  
  class Coordinator: NSObject, UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
      if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
        let velocity = panGesture.velocity(in: panGesture.view)
        
        // Horizontal swipe
        if abs(velocity.x) > abs(velocity.y) {
          return true
        } else {
           return false
        }
      }
      
      return false
    }
  }
}

extension CGPoint {
  var toSize: CGSize {
    return CGSize(width: x, height: y)
  }
}
