import UIKit
import CoreData
import AVFoundation
import Photos

class ProfileViewController: UIViewController {
    
    private let viewModel = ProfileViewModel()
    private var currentUser: User?
    private var isProfileImageChanged = false
    private var selectedProfileImage: UIImage?
    
    private let themeContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6.withAlphaComponent(0.3)
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let themeToggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemBlue
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "pencil.circle.fill"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .systemGray2
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Kullanıcı adı"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .secondarySystemBackground
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "E-posta"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .secondarySystemBackground
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Şifre"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.backgroundColor = .secondarySystemBackground
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = .systemGray
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        textField.rightView = button
        textField.rightViewMode = .always
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Değişiklikleri Kaydet", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        loadUserData()
        updateThemeButtonImage()
    }
    
    private func setupUI() {
        title = "Profil"
        view.backgroundColor = .systemBackground
        
        view.addSubview(profileImageView)
        view.addSubview(editButton)
        view.addSubview(themeContainer)
        view.addSubview(usernameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(saveButton)
        
        themeContainer.addSubview(themeToggleButton)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            
            editButton.widthAnchor.constraint(equalToConstant: 30),
            editButton.heightAnchor.constraint(equalToConstant: 30),
            editButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor),
            editButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor),
            
            themeContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            themeContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            themeContainer.widthAnchor.constraint(equalToConstant: 40),
            themeContainer.heightAnchor.constraint(equalToConstant: 40),
            
            themeToggleButton.centerXAnchor.constraint(equalTo: themeContainer.centerXAnchor),
            themeToggleButton.centerYAnchor.constraint(equalTo: themeContainer.centerYAnchor),
            themeToggleButton.widthAnchor.constraint(equalToConstant: 24),
            themeToggleButton.heightAnchor.constraint(equalToConstant: 24),
            
            usernameTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 40),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            emailTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            saveButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        profileImageView.layer.cornerRadius = 60
        
        // Add tap gesture to profile image
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(tapGesture)
    }
    
    private func setupActions() {
        if let button = passwordTextField.rightView as? UIButton {
            button.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
        }
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        themeToggleButton.addTarget(self, action: #selector(themeToggleTapped), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }
    
    private func loadUserData() {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                currentUser = user
                usernameTextField.text = user.username
                emailTextField.text = user.email
                passwordTextField.text = user.password
                
                // Load profile image
                if let imageData = UserDefaults.standard.data(forKey: "userProfileImage"),
                   let savedImage = UIImage(data: imageData) {
                    profileImageView.image = savedImage
                    selectedProfileImage = savedImage
                }
            }
        } catch {
            print("Error fetching user: \(error)")
        }
    }
    
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc private func editButtonTapped() {
        let alertController = UIAlertController(
            title: "Profil Fotoğrafını Değiştir",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let cameraAction = UIAlertAction(title: "Fotoğraf Çek", style: .default) { [weak self] _ in
            self?.checkCameraPermission()
        }
        
        let photoLibraryAction = UIAlertAction(title: "Galeriden Seç", style: .default) { [weak self] _ in
            self?.checkPhotoLibraryPermission()
        }
        
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        
        // iPad için popover presentation
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = editButton
            popoverController.sourceRect = editButton.bounds
        }
        
        present(alertController, animated: true)
    }
    
    private func checkPhotoLibraryPermission() {
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .authorized, .limited:
            presentPhotoLibrary()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                DispatchQueue.main.async {
                    if status == .authorized || status == .limited {
                        self?.presentPhotoLibrary()
                    }
                }
            }
        case .restricted, .denied:
            showPermissionAlert(for: "Galeri")
        @unknown default:
            break
        }
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            presentCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.presentCamera()
                    }
                }
            }
        case .restricted, .denied:
            showPermissionAlert(for: "Kamera")
        @unknown default:
            break
        }
    }
    
    private func showPermissionAlert(for type: String) {
        let alert = UIAlertController(
            title: "\(type) İzni Gerekli",
            message: "Profil fotoğrafını değiştirmek için lütfen Ayarlar'dan \(type.lowercased()) iznini verin.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        alert.addAction(UIAlertAction(title: "Ayarlar", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        
        present(alert, animated: true)
    }
    
    private func presentCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            let alert = UIAlertController(
                title: "Kamera Kullanılamıyor",
                message: "Cihazınızda kamera kullanılamıyor.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Tamam", style: .default))
            present(alert, animated: true)
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    private func presentPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    @objc private func profileImageTapped() {
        editButtonTapped()
    }
    
    @objc private func saveButtonTapped() {
        guard let username = usernameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text else { return }
        
        // Check if fields are not empty
        guard !username.isEmpty && !email.isEmpty && !password.isEmpty else {
            ToastManager.showToast(message: "Lütfen tüm alanları doldurun", in: self, isError: true)
            return
        }
        
        // Update user in Core Data
        if let user = currentUser {
            let context = CoreDataManager.shared.context
            
            // Check if username or email is already taken by another user
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "(username == %@ OR email == %@) AND self != %@", username, email, user)
            
            do {
                let existingUsers = try context.fetch(fetchRequest)
                if !existingUsers.isEmpty {
                    ToastManager.showToast(message: "Bu kullanıcı adı veya e-posta zaten kullanılıyor", in: self, isError: true)
                    return
                }
                
                // Update user information
                user.username = username
                user.email = email
                user.password = password
                
                // Save profile image if changed
                if isProfileImageChanged, let newImage = selectedProfileImage {
                    if let imageData = newImage.jpegData(compressionQuality: 0.7) {
                        UserDefaults.standard.set(imageData, forKey: "userProfileImage")
                        
                        // Notify other view controllers about profile image change
                        NotificationCenter.default.post(
                            name: NSNotification.Name("ProfileImageDidChange"),
                            object: imageData
                        )
                    }
                }
                
                try context.save()
                ToastManager.showToast(message: "Değişiklikler kaydedildi", in: self)
                isProfileImageChanged = false
            } catch {
                print("Error updating user: \(error)")
                ToastManager.showToast(message: "Bir hata oluştu", in: self, isError: true)
            }
        }
    }
    
    @objc private func themeToggleTapped() {
        let newTheme: Theme = ThemeManager.shared.currentTheme == .light ? .dark : .light
        
        // Animasyonlu geçiş
        UIView.animate(withDuration: 0.3, animations: {
            self.themeToggleButton.transform = CGAffineTransform(rotationAngle: .pi)
        }) { _ in
            ThemeManager.shared.currentTheme = newTheme
            self.updateThemeButtonImage()
            
            UIView.animate(withDuration: 0.3) {
                self.themeToggleButton.transform = .identity
            }
        }
    }
    
    private func updateThemeButtonImage() {
        let currentTheme = ThemeManager.shared.currentTheme
        let imageName = currentTheme == .light ? "moon.fill" : "sun.max.fill"
        let image = UIImage(systemName: imageName)?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 16, weight: .medium))
        themeToggleButton.setImage(image, for: .normal)
        
        // Container'ın arka plan rengini güncelle
        UIView.animate(withDuration: 0.3) {
            self.themeContainer.backgroundColor = currentTheme == .light ? 
                .systemGray6.withAlphaComponent(0.3) : 
                .systemGray6.withAlphaComponent(0.1)
        }
    }
    
    override func themeDidChange(_ notification: Notification) {
        super.themeDidChange(notification)
        guard let theme = notification.object as? Theme else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = theme.backgroundColor
            self.profileImageView.backgroundColor = theme.secondaryBackgroundColor
            self.editButton.backgroundColor = theme.backgroundColor
            self.editButton.tintColor = theme.tintColor
            self.themeToggleButton.tintColor = theme.tintColor
            self.usernameTextField.backgroundColor = theme.secondaryBackgroundColor
            self.emailTextField.backgroundColor = theme.secondaryBackgroundColor
            self.passwordTextField.backgroundColor = theme.secondaryBackgroundColor
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            profileImageView.image = editedImage
            selectedProfileImage = editedImage
            isProfileImageChanged = true
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileImageView.image = originalImage
            selectedProfileImage = originalImage
            isProfileImageChanged = true
        }
        
        dismiss(animated: true)
    }
} 
