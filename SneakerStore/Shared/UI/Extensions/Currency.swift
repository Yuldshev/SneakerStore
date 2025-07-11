import Foundation

extension Int {
  func asCurrency() -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = "USD"
    formatter.locale = Locale(identifier: "en_US")
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 0
    
    return formatter.string(from: NSNumber(value: self)) ?? "$\(self)"
  }
}
