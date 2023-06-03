
import Foundation
import CoreData

protocol FavoriteStorageProtocol {
    
    var favorites: [ImageByTextEntity] {get}
    
    func addToFavorites(text: String, imageData: Data)
    
    func removeFromFavorites(favorite: ImageByTextEntity)
    
    func addObserver(_ observer: any FavoritesStorageObserverProtocol)
}

protocol FavoritesStorageObserverProtocol {
    func didAddToFavorites(favorite: ImageByTextEntity)
}
