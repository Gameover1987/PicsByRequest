
import Foundation
@testable import PicsByRequest

final class MockFavoriteStorage : FavoriteStorageProtocol {
    
    
    var favorites: [PicsByRequest.ImageByTextEntity] = []
    
    func addToFavorites(text: String, imageData: Data) {
        
    }
    
    func removeFromFavorites(favorite: PicsByRequest.ImageByTextEntity) {
        
    }
    
    func addObserver(_ observer: PicsByRequest.FavoritesStorageObserverProtocol) {
        
    }
    
    
}
