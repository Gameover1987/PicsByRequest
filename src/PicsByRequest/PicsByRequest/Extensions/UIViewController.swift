
import UIKit

extension UIViewController {
    
    func showMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
