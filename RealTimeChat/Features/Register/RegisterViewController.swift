import UIKit
import PhotosUI
import FirebaseAuth

final class RegisterViewController: BaseViewController {
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    private let firstnameField = BaseTextField()
    private let lastnameField = BaseTextField()
    private let usernameField = BaseTextField()
    private let emailField = BaseTextField()
    private let passwordField = BaseTextField()
    private let registerButton = PrimaryButton(type: .system)
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupFrames()
    }
}
// MARK: - Actions
extension RegisterViewController {
    @objc private func registerButtonTapped() {
        guard let email = emailField.text,
              let password = passwordField.text,
              let firstname = firstnameField.text,
              let lastname = lastnameField.text
        else { return }
        registerButton.isEnabled = false
        
        Auth.auth().createUser(withEmail: email, password: password) {[weak self] authResult, error in
            if let error {
                self?.registerButton.isEnabled = true
            } else if let uid = authResult?.user.uid {
                let user = ChatAppUser(firstName: firstname, lastName: lastname, emailAddress: email, uid: uid)
                DatabaseManager.shared.insertUser(with: user)
                self?.navigationController?.dismiss(animated: true)
            }
        }
    }
    
    @objc private func didTapChangeProfilePicture() {
        presentPhotoActionSheet()
    }
}
// MARK: - Setup Views
extension RegisterViewController {
    override func setupViews() {
        super.setupViews()
        setupScrollView()
        setupImageView()
        setupFirstnameField()
        setupLastnameField()
        setupUsernameField()
        setupEmailField()
        setupPasswordField()
        setupLoginButton()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.clipsToBounds = true
        scrollView.alwaysBounceVertical = true
    }
    
    private func setupImageView() {
        scrollView.addSubview(imageView)
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapChangeProfilePicture))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(gesture)
        imageView.isUserInteractionEnabled = true
    }
    
    private func setupFirstnameField() {
        scrollView.addSubview(firstnameField)
        firstnameField.autocapitalizationType = .none
        firstnameField.autocorrectionType = .no
        firstnameField.returnKeyType = .continue
        firstnameField.placeholder = "First name..."
        firstnameField.delegate = self
    }
    
    private func setupLastnameField() {
        scrollView.addSubview(lastnameField)
        lastnameField.autocapitalizationType = .none
        lastnameField.autocorrectionType = .no
        lastnameField.returnKeyType = .continue
        lastnameField.placeholder = "Last name..."
        lastnameField.delegate = self
    }
    
    private func setupUsernameField() {
        scrollView.addSubview(usernameField)
        usernameField.autocapitalizationType = .none
        usernameField.autocorrectionType = .no
        usernameField.returnKeyType = .continue
        usernameField.placeholder = "Username..."
        usernameField.delegate = self
    }
    
    private func setupEmailField() {
        scrollView.addSubview(emailField)
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.returnKeyType = .continue
        emailField.placeholder = "Email Address..."
        emailField.delegate = self
    }
    
    private func setupPasswordField() {
        scrollView.addSubview(passwordField)
        passwordField.autocapitalizationType = .none
        passwordField.autocorrectionType = .no
        passwordField.returnKeyType = .done
        passwordField.placeholder = "Password..."
        passwordField.isSecureTextEntry = true
        passwordField.delegate = self
    }
    
    private func setupLoginButton() {
        scrollView.addSubview(registerButton)
        registerButton.setTitle("Register", for: .normal)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .primaryActionTriggered)
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
        imageView.layer.cornerRadius = imageView.width / 2
        firstnameField.frame = CGRect(x: padding,
                                  y: imageView.bottom + spacing,
                                  width: width,
                                  height: height)
        lastnameField.frame = CGRect(x: padding,
                                  y: firstnameField.bottom + spacing,
                                  width: width,
                                  height: height)
        usernameField.frame = CGRect(x: padding,
                                  y: lastnameField.bottom + spacing,
                                  width: width,
                                  height: height)
        emailField.frame = CGRect(x: padding,
                                  y: usernameField.bottom + spacing,
                                  width: width,
                                  height: height)
        passwordField.frame = CGRect(x: padding,
                                  y: emailField.bottom + spacing,
                                  width: width,
                                  height: height)
        registerButton.frame = CGRect(x: padding,
                                  y: passwordField.bottom + spacing,
                                  width: width,
                                  height: height)
    }
}
// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstnameField {
            lastnameField.becomeFirstResponder()
        } else if textField == lastnameField {
            usernameField.becomeFirstResponder()
        } else if textField == usernameField {
            emailField.becomeFirstResponder()
        } else if textField == emailField {
            passwordField.becomeFirstResponder()
        } else {
            passwordField.resignFirstResponder()
            registerButtonTapped()
        }
        return true
    }
}
// MARK: - PHPickerViewControllerDelegate
extension RegisterViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            let previousImage = imageView.image
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    guard let self = self,
                            let image = image as? UIImage,
                            self.imageView.image == previousImage else { return }
                    self.imageView.image = image
                }
            }
        }
    }
    
    func presentPhotoPicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
}
// MARK: - UIImagePickerControllerDelegate
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(
            title: "Profile Picture",
            message: "How would you like to select a picture?",
            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel))
        actionSheet.addAction(UIAlertAction(
            title: "Take Photo",
            style: .default,
            handler: { [weak self] _ in self?.presentCamera() }))
        actionSheet.addAction(UIAlertAction(
            title: "Choose Photo",
            style: .default,
            handler: { [weak self] _ in self?.presentPhotoPicker() }))
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let controller = UIImagePickerController()
        controller.sourceType = .camera
        controller.delegate = self
        controller.allowsEditing = true
        present(controller, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        self.imageView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
