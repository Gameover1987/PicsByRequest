
import Foundation
import CoreData

protocol FavoriteStorageProtocol {
    
    var favorites: [FavoriteEntity] {get}
    
    func addToFavorites(text: String, imageData: Data)
    
    func removeFromFavorites(favorite: FavoriteEntity)
    
    func addObserver(_ observer: any FavoritesStorageObserverProtocol)
}

protocol FavoritesStorageObserverProtocol {
    func didAddToFavorites(favorite: FavoriteEntity)
}
