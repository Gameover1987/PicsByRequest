
import Foundation

final class FavoritesViewModel {
    
    private let storage: FavoriteStorageProtocol
    
    init(storage: FavoriteStorageProtocol) {
        self.storage = storage
        
        self.storage.addObserver(self)
        self.favorites = storage.favorites
    }
    
    var favorites: [ImageByTextEntity] = []

    var favoritesCollectionChangedAction: (() -> Void)?
    
    var deleteRowsAction: ((_ indexPath: IndexPath) -> Void)?
    
    func removeFromFavorites(favorite: ImageByTextEntity) {
        guard let index = self.storage.favorites.firstIndex(of: favorite) else {return}
        
        self.storage.removeFromFavorites(favorite: favorite)
        self.favorites.remove(at: index)
        
        let indexPath = IndexPath(row: index, section: 0)
        
        deleteRowsAction?(indexPath)
    }
}

extension FavoritesViewModel : FavoritesStorageObserverProtocol {
    func didAddToFavorites(favorite: ImageByTextEntity) {
        favorites = storage.favorites
        
        favoritesCollectionChangedAction?()
    }
}
