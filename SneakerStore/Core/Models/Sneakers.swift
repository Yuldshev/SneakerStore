import Foundation

struct Sneaker: Equatable, Identifiable, Hashable, Codable {
  let id: String
  let name: String
  let brand: SneakerBrand
  let gender: SneakerGender
  let silhouette: String
  let story: String
  let price: Int
  let thumbnail: URL
  var variants: [SneakerVariant]
}

struct SneakerVariant: Equatable, Identifiable, Hashable, Codable {
  let id: String
  let colorway: String
  let retailPrice: Int
  let releaseDate: String
  let images: URL
}

extension Sneaker {
  static var mock: [Sneaker] {
    (1...6).map { i in
      Sneaker(
        id: "",
        name: "Sneaker Name",
        brand: .asics,
        gender: .men,
        silhouette: "Gel Nyc",
        story: "",
        price: 100,
        thumbnail: URL(string: "https://image.goat.com/attachments/product_template_pictures/images/110/512/498/original/1203A542_022.png.png")!,
        variants: [
          SneakerVariant(
            id: "\(i)",
            colorway: "",
            retailPrice: 100,
            releaseDate: "",
            images: URL(string: "https://image.goat.com/attachments/product_template_pictures/images/110/512/498/original/1203A542_022.png.png")!
          )
        ]
      )
    }
  }
}
