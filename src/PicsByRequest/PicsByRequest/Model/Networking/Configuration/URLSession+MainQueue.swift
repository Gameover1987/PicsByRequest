import Foundation

extension URLSession {
    static func defaultSession() -> URLSession {
        return URLSession(configuration: URLSessionConfiguration.default,
                          delegate: nil, delegateQueue: OperationQueue.main)
    }
}
