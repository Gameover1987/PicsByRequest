
import Foundation

final class PicsByRequestViewModel {
    
    private let picsProvider: PicsProviderProtocol
    private let storage: FavoriteStorageProtocol
    
    init(picsProvider: PicsProviderProtocol, favoriteStorage: FavoriteStorageProtocol) {
        self.picsProvider = picsProvider
        self.storage = favoriteStorage
    }
    
    var pictureLoadedAction: ((ImageResponse) -> Void)?
    var errorAction: ((Error) -> Void)?
    
    func loadPicture(by text: String) {
        self.picsProvider.requestPicture(by: text) { [weak self] result in
            
            guard let self = self else {return}
            
            switch result {
            case .success(let response):
                pictureLoadedAction?(response)
                
            case .failure(let error):
                errorAction?(error)
            }
        }
    }
    
    func addToFavorites(text: String, imageData: Data) {
        storage.addToFavorites(text: text, imageData: imageData)
    }
}
