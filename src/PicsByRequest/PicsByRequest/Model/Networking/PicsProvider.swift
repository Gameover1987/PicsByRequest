
import Foundation

protocol PicsProviderProtocol {
    func requestPicture(by text: String, completion: @escaping(Result<ImageResponse, Error>) -> Void)
}
