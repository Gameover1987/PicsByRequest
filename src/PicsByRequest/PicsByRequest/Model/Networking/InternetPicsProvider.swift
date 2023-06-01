
import Foundation

final class InternetPicsProvider : PicsProviderProtocol {
    
    static let shared = InternetPicsProvider()
    
    private init() {}
    
    func requestPicture(by text: String, completion: @escaping (Result<ImageResponse, Error>) -> Void) {
        var everythingUrl = URLComponents(string: "https://dummyimage.com/100x100&text="+text)
        
        guard let url = everythingUrl?.url else {
            fatalError("Error creating dummyimage.com from components")
        }
        
        let request = URLRequest(url: url)
        print(url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(ApiErrors.dataIsNil))
                return
            }
            
            do
            {
                let response = ImageResponse(text: text, imageData: data)
                completion(.success(response))
            }
            catch {
                print(error)
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
