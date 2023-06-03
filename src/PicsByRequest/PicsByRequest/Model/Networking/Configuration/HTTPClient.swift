
import Foundation

typealias HTTPResult = (Data?, Error?) -> Void

class HTTPClient {
    private let session: URLSession

    init(session: URLSession = NetworkConfiguration.urlSession) {
        self.session = session
    }

    func get(url: URL, completion: HTTPResult) {
        let task = session.dataTask(with: url) { (data, response, error) -> Void in
            // ... //
        }
        task.resume()
    }
}
