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
  let image: URL
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
        story: "In 1985 on a Nike Europe tour, Michael Jordan shattered a backboard when throwing down a monstrous dunk while wearing an orange, black, and white uniform. Commemorating the moment and uniform, a 2015 Air Jordan 1 #39;Shattered Backboard #39; (aka #39;Shattered Backboard #39; 1.0) sneaker was released. Shortly after in the Fall of 2016, an Air Jordan 1 #39;Shattered Backboard Away #39; (aka  #39;Reverse #39; and #39;Shattered Backboard 2.#39;) was released. This sneaker keeps the black laces and Nike branding, but swaps out the orange toe box and black around the toe and tongue for white.",
        price: 100,
        thumbnail: URL(string: "https://image.goat.com/attachments/product_template_pictures/images/110/512/498/original/1203A542_022.png.png")!,
        variants: [
          SneakerVariant(
            id: "Oxygen",
            colorway: "Oxygen Purple/Oxygen Purple-Monsoon Blue-Melon Tint-White",
            image: URL(string: "https://image.goat.com/attachments/product_template_pictures/images/110/512/498/original/1203A542_022.png.png")!
          ),
          
          SneakerVariant(
            id: "Sail",
            colorway: "Sail/Starfish-Black",
            image: URL(string: "")!
          )
        ]
      )
    }
  }
}
