import UIKit

protocol ProfileViewModelDelegate: AnyObject {
    func profileImageDidUpdate()
    func didReceiveError(_ error: Error)
}

class ProfileViewModel {
    // MARK: - Properties
    weak var delegate: ProfileViewModelDelegate?
    
    private(set) var profileImage: UIImage? {
        didSet {
            delegate?.profileImageDidUpdate()
        }
    }
    
    // MARK: - Methods
    func updateProfileImage(_ image: UIImage) {
        profileImage = image
        // Burada profil fotoğrafını kaydetme işlemleri yapılabilir
        // Örneğin: UserDefaults, Core Data veya bir backend servisi
    }
} 