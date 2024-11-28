import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTheme()
        setupViewControllers()
        customizeTabBarAppearance()
    }
    
    override func themeDidChange(_ notification: Notification) {
        super.themeDidChange(notification)
        guard let theme = notification.object as? Theme else { return }
        
        // Update TabBar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = theme.backgroundColor
        
        // Update colors
        tabBar.tintColor = theme.tintColor
        tabBar.unselectedItemTintColor = theme.secondaryTextColor
        
        // Apply appearance
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    private func setupViewControllers() {
        // Home Tab
        let homeVC = HomeViewController()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        homeNav.interactivePopGestureRecognizer?.isEnabled = false
        
        // My Learning Tab
        let learningVC = MyLearningViewController()
        let learningNav = UINavigationController(rootViewController: learningVC)
        learningNav.tabBarItem = UITabBarItem(
            title: "My Learning",
            image: UIImage(systemName: "book"),
            selectedImage: UIImage(systemName: "book.fill")
        )
        learningNav.interactivePopGestureRecognizer?.isEnabled = false
        
        // Bookmark Tab
        let bookmarkVC = BookmarkViewController()
        let bookmarkNav = UINavigationController(rootViewController: bookmarkVC)
        bookmarkNav.tabBarItem = UITabBarItem(
            title: "Bookmark",
            image: UIImage(systemName: "bookmark"),
            selectedImage: UIImage(systemName: "bookmark.fill")
        )
        bookmarkNav.interactivePopGestureRecognizer?.isEnabled = false
        
        // Profile Tab
        let profileVC = ProfileViewController()
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        profileNav.interactivePopGestureRecognizer?.isEnabled = false
        
        // Configure each navigation controller
        [homeNav, learningNav, bookmarkNav, profileNav].forEach { nav in
            nav.isNavigationBarHidden = false
            nav.navigationBar.prefersLargeTitles = true
            nav.modalPresentationStyle = .fullScreen
            nav.definesPresentationContext = true
        }
        
        // Set ViewControllers
        viewControllers = [homeNav, learningNav, bookmarkNav, profileNav]
        
        // Set default selected index
        selectedIndex = 0
        
        // Set tab bar item tags
        homeNav.tabBarItem.tag = 0
        learningNav.tabBarItem.tag = 1
        bookmarkNav.tabBarItem.tag = 2
        profileNav.tabBarItem.tag = 3
    }
    
    private func customizeTabBarAppearance() {
        // TabBar Background
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        // Normal state colors
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.systemGray
        ]
        
        // Selected state colors
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.systemBlue
        ]
        
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes
        
        // Icon Colors
        appearance.stackedLayoutAppearance.normal.iconColor = .systemGray
        appearance.stackedLayoutAppearance.selected.iconColor = .systemBlue
        
        // Apply appearance
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        // Additional customization
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .systemGray
        
        // Add shadow
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -3)
        tabBar.layer.shadowRadius = 8
        tabBar.layer.shadowOpacity = 0.1
        
        // Add top border
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 0.5)
        topBorder.backgroundColor = UIColor.systemGray5.cgColor
        tabBar.layer.addSublayer(topBorder)
    }
}
