import UIKit

class WelcomeViewController: BaseViewController {
    let loginButton = PrimaryButton(type: .system)
    let registerButton = SecondaryButton(type: .system)
}
// MARK: - Action
extension WelcomeViewController {
    @objc private func didTapLoginButton() {
        let controller = LoginViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc private func didTapRegisterButton() {
        let controller = RegisterViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
}
// MARK: - Setup Views
extension WelcomeViewController {
    override func setupViews() {
        super.setupViews()
        setupLoginButton()
        setupRegisterButton()
    }
    
    private func setupLoginButton() {
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Login", for: [])
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .primaryActionTriggered)
        NSLayoutConstraint.activate([
            loginButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: loginButton.trailingAnchor, multiplier: 2),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func setupRegisterButton() {
        view.addSubview(registerButton)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.setTitle("Register", for: [])
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .primaryActionTriggered)
        NSLayoutConstraint.activate([
            registerButton.topAnchor.constraint(equalToSystemSpacingBelow: loginButton.bottomAnchor, multiplier: 2),
            registerButton.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor),
            registerButton.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor),
            registerButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
}
