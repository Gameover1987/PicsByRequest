import Foundation
import UIKit

typealias DataCompletion = (Data?, URLResponse?, Error?) -> Void

class SeededURLSession: URLSession {
    override func dataTask(with request: URLRequest, completionHandler: @escaping DataCompletion) -> URLSessionDataTask {
        return SeededDataTask(url: request.url!, completion: completionHandler)
    }
}

class SeededDataTask: URLSessionDataTask {
    private let url: URL
    private let completion: DataCompletion
    private let realSession = URLSession.defaultSession()
    
    static var TestImageData: Data = Data()

    init(url: URL, completion: @escaping DataCompletion) {
        self.url = url
        self.completion = completion
    }

    override func resume() {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data = getImageData()
        completion(data, response, nil)
    }
    
    func getImageData() -> Data {
        let image = UIImage(named: "TestImage")
        let data = image!.pngData()
        return data!
    }
}
