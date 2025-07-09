import Foundation

enum SneakerGender: String, CaseIterable, Codable {
  case child, infant, kids, men, preschool, toddler, unisex, women, youth
  
  var title: String {
    self.rawValue.uppercased()
  }
  
  static func from(_ rawValue: String) -> SneakerGender? {
    let cleanedValue = rawValue.lowercased().replacingOccurrences(of: " ", with: "")
    return SneakerGender.allCases.first { gender in
      gender.rawValue.lowercased().replacingOccurrences(of: " ", with: "") == cleanedValue
    }
  }
}
