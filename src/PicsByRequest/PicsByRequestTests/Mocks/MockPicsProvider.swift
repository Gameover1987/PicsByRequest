
import Foundation
@testable import PicsByRequest

enum ApiErrorsForTest : String, Error {
    case gtfoException = "In this place programmers have fun!"
}

final class MockPicsProvider : PicsProviderProtocol {
    
    static var successResponse = ImageResponse(text: "", imageData: Data(), created: Date())
    
    init(shouldFail: Bool) {
        self.shouldFail = shouldFail
    }
    
    let shouldFail: Bool
    
    func requestPicture(by text: String, completion: @escaping (Result<PicsByRequest.ImageResponse, Error>) -> Void) {
        
        if shouldFail {
            completion(.failure(ApiErrorsForTest.gtfoException))
            return
        }
        
        MockPicsProvider.successResponse.text = text
        completion(.success(MockPicsProvider.successResponse))
    }
    
    
}
