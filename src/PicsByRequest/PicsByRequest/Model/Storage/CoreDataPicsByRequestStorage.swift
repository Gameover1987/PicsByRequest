
import Foundation
import CoreData

final class CoreDataFavoriteStorage : FavoriteStorageProtocol {

    static let shared = CoreDataFavoriteStorage()
    
    private static let maxRecordCount = 10
    
    private var observers: [FavoritesStorageObserverProtocol] = []
    
    private init() {
        fetchFavorites()
    }
    
    var favorites: [ImageByTextEntity] = []
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func addToFavorites(text: String, imageData: Data) {
        let request = ImageByTextEntity.fetchRequest()
        request.predicate = NSPredicate(format: "text == %@", text)
        
        let context = persistentContainer.viewContext
        
        if let imageByTextEntity = (try? context.fetch(request))?.first {
            return
        }
        
        let imageByTextEntity = ImageByTextEntity(context: context)
        imageByTextEntity.text = text
        imageByTextEntity.imageData = imageData
        imageByTextEntity.createdAt = Date()
        
        save(in: context)
        
        fetchFavorites()
        
        actualizeRecordCount()
        
        for observer in observers {
            observer.didAddToFavorites(favorite: imageByTextEntity)
        }
    }
    
    func addObserver(_ observer: FavoritesStorageObserverProtocol) {
        observers.append(observer)
    }
    
    func removeFromFavorites(favorite: ImageByTextEntity) {
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
    
    private func getOrCreateImage(by text: String, imageData: Data, in context: NSManagedObjectContext) -> ImageByTextEntity {
        let request = ImageByTextEntity.fetchRequest()
        request.predicate = NSPredicate(format: "text == %@", text)
        
        if let imageByTextEntity = (try? context.fetch(request))?.first {
            return imageByTextEntity
        }
        else {
            let imageByTextEntity = ImageByTextEntity(context: context)
            imageByTextEntity.text = text
            imageByTextEntity.imageData = imageData
            imageByTextEntity.createdAt = Date()
            
            return imageByTextEntity
        }
    }
    
    private func fetchFavorites() {
        let request = ImageByTextEntity.fetchRequest()
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
