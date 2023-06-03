
import Foundation
import CoreData

final class CoreDataFavoriteStorage : FavoriteStorageProtocol {

    static let shared = CoreDataFavoriteStorage()
    
    private static let maxRecordCount = 10
    
    private var observers: [FavoritesStorageObserverProtocol] = []
    
    private init() {
        fetchFavorites()
    }
    
    var favorites: [FavoriteEntity] = []
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func addToFavorites(text: String, imageData: Data) {
        let request = FavoriteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "text == %@", text)
        
        let context = persistentContainer.viewContext
        
        if let favoriteEntity = (try? context.fetch(request))?.first {
            return
        }
        
        let favoriteEntity = FavoriteEntity(context: context)
        favoriteEntity.text = text
        favoriteEntity.imageData = imageData
        favoriteEntity.createdAt = Date()
        
        save(in: context)
        
        fetchFavorites()
        
        actualizeRecordCount()
        
        for observer in observers {
            observer.didAddToFavorites(favorite: favoriteEntity)
        }
    }
    
    func addObserver(_ observer: FavoritesStorageObserverProtocol) {
        observers.append(observer)
    }
    
    func removeFromFavorites(favorite: FavoriteEntity) {
        persistentContainer.viewContext.delete(favorite)
        
        save(in: persistentContainer.viewContext)
        
        fetchFavorites()
    }
    
    private func actualizeRecordCount() {
        if (favorites.count <= CoreDataFavoriteStorage.maxRecordCount) {
            return
        }
        
        removeFromFavorites(favorite: favorites.last!)
    }
    
    private func fetchFavorites() {
        let request = FavoriteEntity.fetchRequest()
        do {
            request.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: false)
            ]
            favorites = try persistentContainer.viewContext.fetch(request)
        } catch {
            print(error)
        }
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PicsByRequest")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private func save (in context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
