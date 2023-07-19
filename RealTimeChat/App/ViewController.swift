import UIKit
import FirebaseAuth

class ViewController: BaseViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }
}
// MARK: Actions
extension ViewController {
    override func setupViews() {
        
    }
    
    private func validateAuth() {
        if Auth.auth().currentUser == nil {
            let controller = UINavigationController(rootViewController: WelcomeViewController())
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: false)
        } else {
            do {
                try Auth.auth().signOut()
            } catch {}
        }
    }
}
