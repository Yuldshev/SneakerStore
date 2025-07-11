import SwiftUI
import Kingfisher

struct SpinnerView: View {
  let photo: [String]
  let sensitivity: CGFloat = 15.0

  @State private var currentIndex = 0
  @State private var dragTranslation: CGFloat = 0
  @State private var preloadedImages: [URL: UIImage] = [:]
  @State private var didStartPreloading = false

  private var displayedImageIndex: Int {
    guard !photo.isEmpty else { return 0 }
    let offset = Int(dragTranslation / sensitivity)
    let newIndex = currentIndex - offset
    let wrapped = (newIndex % photo.count + photo.count) % photo.count
    return wrapped
  }

  var body: some View {
    Group {
      if photo.isEmpty {
        ContentUnavailableView("No photos", systemImage: "photo")
      } else {
        let imageURL = URL(string: photo[displayedImageIndex])!
        if let image = preloadedImages[imageURL] {
          Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .gesture(dragGesture)
        } else {
          ProgressView()
        }
      }
    }
    .onAppear {
      if !didStartPreloading {
        preloadImages()
        didStartPreloading = true
      }
    }
  }

  private var dragGesture: some Gesture {
    DragGesture(minimumDistance: 0)
      .onChanged { value in
        dragTranslation = value.translation.width
      }
      .onEnded { _ in
        currentIndex = displayedImageIndex
        dragTranslation = 0
      }
  }

  private func preloadImages() {
    let urls = photo.compactMap { URL(string: $0) }

    for url in urls {
      KingfisherManager.shared.retrieveImage(with: url) { result in
        switch result {
          case .success(let value):
            DispatchQueue.main.async {
              preloadedImages[url] = value.image
            }
          case .failure(let error):
            print("Image load failed: \(url) → \(error.localizedDescription)")
        }
      }
    }
  }
}

