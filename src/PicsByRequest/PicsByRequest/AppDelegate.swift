
import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        self.window = window
        
        
        let picsController = PicsByRequestController();
        picsController.tabBarItem.title = "Pics"
        
        let favoritesController = FavoritePicsViewController();
        favoritesController.tabBarItem.title = "Favotites"
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([picsController, favoritesController], animated: false)
        
        tabBarController.tabBar.backgroundColor = Colors.TabBar.background
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width:tabBarController.tabBar.frame.size.width, height: 0.5))
        lineView.backgroundColor = Colors.TabBar.borderColor
        tabBarController.tabBar.addSubview(lineView)
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        return true
    }
}
