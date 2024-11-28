import UIKit
import CoreData

class SignInViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "LearnConnect"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Kullanıcı adı"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .secondarySystemBackground
        textField.returnKeyType = .next
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Şifre"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.backgroundColor = .secondarySystemBackground
        textField.returnKeyType = .done
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = .systemGray
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        textField.rightView = button
        textField.rightViewMode = .always
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Giriş Yap", for: .normal)
        button.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Kayıtlı değilseniz kayıt olun", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupKeyboardHandling()
        
        if let button = passwordTextField.rightView as? UIButton {
            button.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.addSubview(titleLabel)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            usernameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            
            signUpButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func setupActions() {
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
    }
    
    private func setupKeyboardHandling() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @objc private func textFieldDidChange() {
        let isEnabled = !(usernameTextField.text?.isEmpty ?? true) && !(passwordTextField.text?.isEmpty ?? true)
        signInButton.backgroundColor = isEnabled ? .systemBlue : .systemBlue.withAlphaComponent(0.5)
        signInButton.isEnabled = isEnabled
    }
    
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc private func signInTapped() {
        guard let username = usernameTextField.text,
              let password = passwordTextField.text else { return }
        
        print("Giriş denemesi - Kullanıcı adı: \(username)")
        
        // Check if user exists in Core Data
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)
        
        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                // User found, check password
                if user.password == password {
                    print("Giriş başarılı - Kullanıcı adı: \(username)")
                    
                    // Save login state
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                    UserDefaults.standard.set(username, forKey: "loggedInUsername")
                    UserDefaults.standard.synchronize()
                    
                    // Switch to tab bar controller using SceneDelegate
                    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                        let tabBarController = CustomTabBarController()
                        sceneDelegate.switchRootViewController(to: tabBarController, animated: true)
                    }
                } else {
                    print("Giriş başarısız - Şifre hatalı - Kullanıcı adı: \(username)")
                    ToastManager.showToast(
                        message: "Kullanıcı adı veya şifre hatalı",
                        in: self,
                        isError: true
                    )
                }
            } else {
                print("Giriş başarısız - Kullanıcı bulunamadı - Kullanıcı adı: \(username)")
                ToastManager.showToast(
                    message: "Böyle bir kullanıcı adı veya şifre bulunmamaktadır",
                    in: self,
                    isError: true
                )
            }
        } catch {
            print("Core Data error: \(error)")
            ToastManager.showToast(
                message: "Bir hata oluştu, lütfen tekrar deneyin",
                in: self,
                isError: true
            )
        }
    }
    
    @objc private func signUpTapped() {
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func themeDidChange(_ notification: Notification) {
        super.themeDidChange(notification)
        guard let theme = notification.object as? Theme else { return }
        
        titleLabel.textColor = theme.textColor
        usernameTextField.backgroundColor = theme.secondaryBackgroundColor
        passwordTextField.backgroundColor = theme.secondaryBackgroundColor
    }
}

// MARK: - UITextFieldDelegate
extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            signInTapped()
        }
        return true
    }
} 
