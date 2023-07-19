import UIKit
import FirebaseAuth

final class LoginViewController: BaseViewController {
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    private let emailField = BaseTextField()
    private let passwordField = BaseTextField()
    private let loginButton = PrimaryButton(type: .system)
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupFrames()
    }
}
// MARK: - Actions
extension LoginViewController {
    @objc private func loginButtonTapped() {
        guard let email = emailField.text,
              let password = passwordField.text,
              !email.isEmpty,
              password.count > 5
        else {
            alertUserLoginError()
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) {[weak self] authResult, error in
            if let error {
                print("DEBUG: ", error.localizedDescription)
            } else if authResult?.user != nil {
                self?.navigationController?.dismiss(animated: true)
            }
        }
    }
    
    private func alertUserLoginError() {
        let alert = UIAlertController(title: "Woops",
                                      message: "Please, enter all information to log in.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - Setup Views
extension LoginViewController {
    override func setupViews() {
        super.setupViews()
        title = "Log In"
        setupScrollView()
        setupImageView()
        setupEmailField()
        setupPasswordField()
        setupLoginButton()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.clipsToBounds = true
    }
    
    private func setupImageView() {
        scrollView.addSubview(imageView)
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
    }
    
    private func setupEmailField() {
        scrollView.addSubview(emailField)
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.returnKeyType = .continue
        emailField.delegate = self
        emailField.placeholder = "Email ..."
    }
    
    private func setupPasswordField() {
        scrollView.addSubview(passwordField)
        passwordField.autocapitalizationType = .none
        passwordField.autocorrectionType = .no
        passwordField.returnKeyType = .done
        passwordField.isSecureTextEntry = true
        passwordField.delegate = self
        passwordField.placeholder = "Password ..."
    }
    
    private func setupLoginButton() {
        scrollView.addSubview(loginButton)
        loginButton.setTitle("Log In", for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .primaryActionTriggered)
    }
    
    private func setupFrames() {
        scrollView.frame = view.bounds
        
        let size = scrollView.width / 3
        let padding = 30.0
        let spacing = 10.0
        let height = 52.0
        let width = scrollView.width - 2 * padding
        imageView.frame = CGRect(x: (scrollView.width - size) / 2,
                                 y: 20,
                                 width: size,
                                 height: size)
        emailField.frame = CGRect(x: padding,
                                  y: imageView.bottom + spacing,
                                  width: width,
                                  height: height)
        passwordField.frame = CGRect(x: padding,
                                  y: emailField.bottom + spacing,
                                  width: width,
                                  height: height)
        loginButton.frame = CGRect(x: padding,
                                  y: passwordField.bottom + spacing,
                                  width: width,
                                  height: height)
    }
}
// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            passwordField.resignFirstResponder()
            loginButtonTapped()
        }
        return true
    }
}
