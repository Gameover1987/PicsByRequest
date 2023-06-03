
import Foundation

final class InternetPicsProvider : PicsProviderProtocol {
    
    static let shared = InternetPicsProvider()
    
    private let maxCacheSize = 50
    private var cache: [String : ImageResponse] = [:]
    
    private init() {}
    
    func requestPicture(by text: String, completion: @escaping (Result<ImageResponse, Error>) -> Void) {
        
        actualizeCache()
        
        if let cachedResponse = cache[text] {
            completion(.success(cachedResponse))
            return
        }
        
        let request = getRequest(by: text)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(ApiErrors.dataIsNil))
                return
            }
            
            let response = ImageResponse(text: text, imageData: data, created: Date())
            self?.cache[text] = response
            completion(.success(response))
        }
        
        task.resume()
    }
    
    private func getRequest(by text: String) -> URLRequest {
        let everythingUrl = URLComponents(string: "https://dummyimage.com/100x100&text="+text)
        
        guard let url = everythingUrl?.url else {
            fatalError("Error creating dummyimage.com from components")
        }
        
        let request = URLRequest(url: url)
        return request
    }
    
    private func actualizeCache(){
        if (cache.count > maxCacheSize) {
            cache.removeValue(forKey: cache.first!.key)
        }
    }
}
