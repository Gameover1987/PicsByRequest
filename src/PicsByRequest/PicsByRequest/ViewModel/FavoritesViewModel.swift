
import Foundation

final class FavoritesViewModel {
    
    private let storage: FavoriteStorageProtocol
    
    init(storage: FavoriteStorageProtocol) {
        self.storage = storage
        
        self.storage.addObserver(self)
        self.favorites = storage.favorites
    }
    
    var favorites: [FavoriteEntity] = []

    var favoritesCollectionChangedAction: (() -> Void)?
    
    var deleteRowsAction: ((_ indexPath: IndexPath) -> Void)?
    
    func removeFromFavorites(favorite: FavoriteEntity) {
        guard let index = self.storage.favorites.firstIndex(of: favorite) else {return}
        
        self.storage.removeFromFavorites(favorite: favorite)
        self.favorites.remove(at: index)
        
        let indexPath = IndexPath(row: index, section: 0)
        
        deleteRowsAction?(indexPath)
    }
}

extension FavoritesViewModel : FavoritesStorageObserverProtocol {
    func didAddToFavorites(favorite: FavoriteEntity) {
        favorites = storage.favorites
        
        favoritesCollectionChangedAction?()
    }
}
