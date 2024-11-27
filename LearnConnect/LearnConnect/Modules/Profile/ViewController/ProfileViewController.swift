import UIKit
import AVFoundation  // Kamera izni için
import Photos       // Fotoğraf galerisi izni için

class ProfileViewController: UIViewController {
    
    // MARK: - UI Components
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .systemGray2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Profile"
        
        view.addSubview(profileImageView)
        view.addSubview(editButton)
        view.addSubview(themeContainer)
        themeContainer.addSubview(themeToggleButton)
        
        updateThemeButtonImage()
        
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
            themeToggleButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        themeToggleButton.addTarget(self, action: #selector(themeToggleTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func editButtonTapped() {
        let alertController = UIAlertController(title: "Change Profile Photo",
                                              message: nil,
                                              preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { [weak self] _ in
            self?.checkCameraPermission()
        }
        
        let libraryAction = UIAlertAction(title: "Choose from Library", style: .default) { [weak self] _ in
            self?.checkPhotoLibraryPermission()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        
        // iPad için popover presentation
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = editButton
            popoverController.sourceRect = editButton.bounds
        }
        
        present(alertController, animated: true)
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
    
    // MARK: - Permissions
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            presentCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async {
                        self?.presentCamera()
                    }
                }
            }
        default:
            showPermissionAlert(for: "Camera")
        }
    }
    
    private func checkPhotoLibraryPermission() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            presentPhotoLibrary()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                if status == .authorized {
                    DispatchQueue.main.async {
                        self?.presentPhotoLibrary()
                    }
                }
            }
        default:
            showPermissionAlert(for: "Photo Library")
        }
    }
    
    private func showPermissionAlert(for type: String) {
        let alert = UIAlertController(
            title: "\(type) Access Required",
            message: "Please enable \(type) access in Settings to change your profile photo.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        
        present(alert, animated: true)
    }
    
    // MARK: - Image Picker
    private func presentCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    private func presentPhotoLibrary() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
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
    
    // MARK: - Theme Support
    override func themeDidChange(_ notification: Notification) {
        super.themeDidChange(notification)
        guard let theme = notification.object as? Theme else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = theme.backgroundColor
            self.profileImageView.backgroundColor = theme.secondaryBackgroundColor
            self.editButton.backgroundColor = theme.backgroundColor
            self.editButton.tintColor = theme.tintColor
            self.themeToggleButton.tintColor = theme.tintColor
            self.navigationController?.navigationBar.tintColor = theme.tintColor
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.editedImage] as? UIImage {
            profileImageView.image = image
        }
    }
} 