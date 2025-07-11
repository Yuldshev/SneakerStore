import Foundation
import Alamofire

final class APILogger: EventMonitor {
  func requestDidResume(_ request: Request) {
    print("---API Request Started---")
    let allHeaders = request.request?.allHTTPHeaderFields ?? [:]
    print("Headers: \(allHeaders)")
    print("Request: \(request.description)")
    print("-------------------------")
  }
  
  func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
    print("---API Response Received---")
    
    if let url = response.request?.url?.absoluteString {
      print("URL: \(url)")
    }
    
    if let statusCode = response.response?.statusCode {
      print("Status Code: \(statusCode)")
    }
    
    print("Body:")
    if let data = response.data {
      if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
         let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
        print(String(decoding: jsonData, as: UTF8.self))
      } else {
        print(String(decoding: data, as: UTF8.self))
      }
    } else {
      print("empty")
    }
    
    if let error = response.error {
      print("Error: \(error.localizedDescription)")
    }
    
    print("---End of Response---")
  }
}

