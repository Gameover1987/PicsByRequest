
import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        self.window = window
        
        let picsByRequestViewModel = PicsByRequestViewModel(picsProvider: InternetPicsProvider.shared,
                                                            favoriteStorage: CoreDataFavoriteStorage.shared)
        let picsController = PicsByRequestController(viewModel: picsByRequestViewModel);
        picsController.tabBarItem.title = "Pics"
        picsController.tabBarItem.image = UIImage(named: "Gallery")
        
        let favoritesViewModel = FavoritesViewModel(storage: CoreDataFavoriteStorage.shared)
        let favoritesController = FavoritesViewController(viewModel: favoritesViewModel);
        favoritesController.tabBarItem.title = "Favotites"
        favoritesController.tabBarItem.image = UIImage(named: "Star")
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([picsController, favoritesController], animated: false)
        
        tabBarController.tabBar.backgroundColor = Colors.TabBar.background
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width:tabBarController.tabBar.frame.size.width, height: 0.5))
        lineView.backgroundColor = Colors.TabBar.borderColor
        tabBarController.tabBar.addSubview(lineView)
        
        window.rootViewController = tabBarController
        if #available(iOS 13.0, *) {
            window.overrideUserInterfaceStyle = .light
        }
        window.makeKeyAndVisible()
        
        return true
    }
}
