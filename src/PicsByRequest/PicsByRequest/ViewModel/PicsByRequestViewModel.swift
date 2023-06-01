
import Foundation

final class PicsByRequestViewModel {
    
    private let picsProvider: PicsProviderProtocol
    
    init(picsProvider: PicsProviderProtocol) {
        self.picsProvider = picsProvider
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
}
