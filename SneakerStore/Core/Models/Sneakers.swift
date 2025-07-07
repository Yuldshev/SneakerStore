import Foundation

struct Sneaker: Equatable, Identifiable, Hashable {
  let id: String
  let name: String
  let brand: SneakerBrand
  let gender: SneakerGender
  let silhouette: String
  let story: String
  let price: Int
  let thumbnail: URL
  var variants: [SneakerVariant]
  
  init?(productID: String, dtos: [SneakerDTO]) {
    guard let firstDTO = dtos.first else { return nil }
    
    guard
      let thumbnailURL = URL(string: firstDTO.image.thumbnail),
      let brand = SneakerBrand.from(firstDTO.brand),
      let gender = SneakerGender.from(firstDTO.gender),
      let story = firstDTO.story
    else { return nil }
    
    let variants = dtos.compactMap { SneakerVariant(from: $0) }
    guard !variants.isEmpty else { return nil }
    
    self.id = productID
    self.name = firstDTO.name
    self.brand = brand
    self.gender = gender
    self.silhouette = firstDTO.silhouette ?? ""
    self.story = story
    self.price = firstDTO.retailPrice
    self.thumbnail = thumbnailURL
    self.variants = variants
  }
}

struct SneakerVariant: Equatable, Identifiable, Hashable {
  let id: String
  let colorway: String
  let retailPrice: Int
  let releaseDate: String
  let images: URL
  
  init?(from dto: SneakerDTO) {
    guard let imageURL = URL(string: dto.image.original) else { return nil }
    
    self.id = dto.id
    self.colorway = dto.colorway
    self.retailPrice = dto.retailPrice
    self.releaseDate = dto.releaseDate
    self.images = imageURL
  }
}
