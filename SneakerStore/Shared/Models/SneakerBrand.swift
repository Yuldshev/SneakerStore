import Foundation

enum SneakerBrand: String, CaseIterable, Codable {
  case nike = "NIKE"
  case adidas = "ADIDAS"
  case newbalance = "NEW BALANCE"
  case puma = "PUMA"
  case asics = "ASICS"
  case anta = "ANTA"
  case balenciaga = "BALENCIAGA"
  case balmin = "BALMAIN"
  case chanel = "CHANEL"
  case converse = "CONVERSE"
  case crocs = "CROCS"
  case dior = "DIOR"
  case fendi = "FENDI"
  case fila = "FILA"
  case gucci = "GUCCI"
  case jordan = "JORDAN"
  case oakley = "OAKLEY"
  case sketchers = "SKETCHERS"
  case ugg = "UGG"
  case underarmor = "UNDER ARMOR"
  case louisvuitton = "LOUIS VUITTON"
  case salomon = "SALOMON"
  case vans = "VANS"
  case unknown = ""
  
  static func from(_ rawValue: String) -> SneakerBrand? {
    let cleanedValue = rawValue.lowercased().replacingOccurrences(of: " ", with: "")
    return SneakerBrand.allCases.first { brand in
      brand.rawValue.lowercased().replacingOccurrences(of: " ", with: "") == cleanedValue
    }
  }
  
  static var displayCases: [SneakerBrand] {
    allCases.filter { $0 != .unknown }
  }
}
