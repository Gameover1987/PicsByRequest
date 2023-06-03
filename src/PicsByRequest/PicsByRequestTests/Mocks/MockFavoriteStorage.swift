
import Foundation
@testable import PicsByRequest

final class MockFavoriteStorage : FavoriteStorageProtocol {
    
    
    var favorites: [PicsByRequest.FavoriteEntity] = []
    
    func addToFavorites(text: String, imageData: Data) {
        
    }
    
    func removeFromFavorites(favorite: PicsByRequest.FavoriteEntity) {
        
    }
    
    func addObserver(_ observer: PicsByRequest.FavoritesStorageObserverProtocol) {
        
    }
    
    
}
