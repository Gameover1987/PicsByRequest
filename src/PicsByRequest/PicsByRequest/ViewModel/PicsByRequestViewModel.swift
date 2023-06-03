
import Foundation

final class PicsByRequestViewModel {
    
    private let picsProvider: PicsProviderProtocol
    private let storage: PicsByRequestStorageProtocol
    
    init(picsProvider: PicsProviderProtocol, storage: PicsByRequestStorageProtocol) {
        self.picsProvider = picsProvider
        self.storage = storage
    }
    
    var pictureLoadedAction: ((ImageResponse) -> Void)?
    
    func loadPicture(by text: String) {
        self.picsProvider.requestPicture(by: text) { [weak self] result in
            
            guard let self = self else {return}
            
            switch result {
            case .success(let response):
                pictureLoadedAction?(response)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func addToFavorites(text: String, imageData: Data) {
        storage.addToFavorites(text: text, imageData: imageData)
    }
}
