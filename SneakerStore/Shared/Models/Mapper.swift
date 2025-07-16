import Foundation

enum Mapper {
  static func map(from dtos: [SneakersDTO]) -> [Sneaker] {
    let groupedBySilhoutte = Dictionary(grouping: dtos, by: { $0.silhouette })
    
    let sneakers = groupedBySilhoutte.compactMap { _, productDTOs in
      map(from: productDTOs)
    }
    
    return sneakers.sorted { $0.name < $1.name }
  }
  
  private static func map(from dtos: [SneakersDTO]) -> Sneaker? {
    guard let firstDTO = dtos.first else { return nil }
    
    guard
      let thumbnailURL = URL(string: firstDTO.image.thumbnail),
      let brand = SneakerBrand.from(firstDTO.brand),
      let gender = SneakerGender.from(firstDTO.gender),
      let silhouette = firstDTO.silhouette, !silhouette.isEmpty,
      let story = firstDTO.story, !story.isEmpty,
      firstDTO.retailPrice > 0
    else { return nil }
    
    let variants = dtos.compactMap(mapToVariant)
    guard !variants.isEmpty else { return nil }
    
    return Sneaker(
      id: firstDTO.id,
      name: firstDTO.name,
      brand: brand,
      gender: gender,
      silhouette: silhouette,
      story: story,
      price: firstDTO.retailPrice,
      thumbnail: thumbnailURL,
      variants: variants
    )
  }
  
  private static func mapToVariant(from dto: SneakersDTO) -> SneakerVariant? {
    guard let image = URL(string: dto.image.original) else { return nil }
    
    return SneakerVariant(
      id: dto.id,
      colorway: dto.colorway,
      image: image
    )
  }
}
