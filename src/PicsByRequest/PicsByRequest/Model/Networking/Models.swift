
import Foundation

struct ImageResponse {
    var text: String
    
    var imageData: Data
}

enum ApiErrors : String, Error {
    case dataIsNil = "Data is nil!"
    case jsonParseError = "JSON parse error"
}
