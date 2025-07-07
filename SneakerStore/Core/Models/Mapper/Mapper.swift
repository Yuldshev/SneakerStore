import Foundation

enum Mapper {
  static func map(from dtos: [SneakerDTO]) -> [Sneaker] {
    let groupedByProductID = Dictionary(grouping: dtos, by: { $0.id })
    
    let sneakers = groupedByProductID.compactMap { productID, productDTOs in
      Sneaker(productID: productID, dtos: productDTOs)
    }
    
    return sneakers.sorted { $0.name < $1.name }
  }
  
  static func map(from dto: SneakerDTO) -> Sneaker {
    return Sneaker(productID: dto.id, dtos: [dto])!
  }
}
