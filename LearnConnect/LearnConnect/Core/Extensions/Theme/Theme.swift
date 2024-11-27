import UIKit

enum Theme: Int {
    case light
    case dark
    
    var backgroundColor: UIColor {
        switch self {
        case .light:
            return .systemBackground
        case .dark:
            return .systemBackground
        }
    }
    
    var secondaryBackgroundColor: UIColor {
        switch self {
        case .light:
            return .secondarySystemBackground
        case .dark:
            return .secondarySystemBackground
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .light:
            return .label
        case .dark:
            return .label
        }
    }
    
    var secondaryTextColor: UIColor {
        switch self {
        case .light:
            return .secondaryLabel
        case .dark:
            return .secondaryLabel
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .light:
            return .systemBlue
        case .dark:
            return .systemBlue
        }
    }
    
    var cellBackgroundColor: UIColor {
        switch self {
        case .light:
            return .secondarySystemBackground
        case .dark:
            return .secondarySystemBackground
        }
    }
    
    var separatorColor: UIColor {
        switch self {
        case .light:
            return .separator
        case .dark:
            return .separator
        }
    }
}

// Theme Manager
class ThemeManager {
    static let shared = ThemeManager()
    private init() {}
    
    var currentTheme: Theme {
        get {
            Theme(rawValue: UserDefaults.standard.integer(forKey: "selectedTheme")) ?? .light
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "selectedTheme")
            applyTheme(newValue)
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = newValue == .dark ? .dark : .light
                }
            }
        }
    }
    
    func applyTheme(_ theme: Theme) {
        NotificationCenter.default.post(name: .themeDidChange, object: theme)
    }
    
    func setupInitialTheme() {
        let savedTheme = currentTheme
        applyTheme(savedTheme)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = savedTheme == .dark ? .dark : .light
            }
        }
    }
}

// Notification extension
extension Notification.Name {
    static let themeDidChange = Notification.Name("themeDidChange")
}

// UIViewController extension for theme support
extension UIViewController {
    func setupTheme() {
        view.backgroundColor = ThemeManager.shared.currentTheme.backgroundColor
        
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(themeDidChange),
                                             name: .themeDidChange,
                                             object: nil)
    }
    
    @objc func themeDidChange(_ notification: Notification) {
        guard let theme = notification.object as? Theme else { return }
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = theme.backgroundColor
        }
    }
} 