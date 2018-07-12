import Foundation
import UIKit

public extension UIViewController {

    func alert(message: String, title: String = "", oKAction: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: oKAction)

        alertController.addAction(OKAction)

        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
