//
//  SceneDelegate.swift
//  LearnConnect
//
//  Created by Ozgun Dogus on 24.11.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        CoreDataManager.shared.persistentContainer = appDelegate.persistentContainer
        
        
        ThemeManager.shared.setupInitialTheme()
        
        
        let loadingVC = LoadingViewController()
        window.rootViewController = loadingVC
        window.makeKeyAndVisible()
        self.window = window
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            self?.showMainInterface()
        }
    }

    private func showMainInterface() {
       
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn") {
            
            let tabBarController = CustomTabBarController()
            switchRootViewController(to: tabBarController)
        } else {
           
            let signInVC = SignInViewController()
            let navigationController = UINavigationController(rootViewController: signInVC)
            switchRootViewController(to: navigationController)
        }
        
       
        NotificationManager.shared.requestAuthorization()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    
    func switchRootViewController(to viewController: UIViewController, animated: Bool = true) {
        guard let window = self.window else { return }
        
        if animated {
            UIView.transition(with: window,
                            duration: 0.3,
                            options: .transitionCrossDissolve,
                            animations: {
                window.rootViewController = viewController
            })
        } else {
            window.rootViewController = viewController
        }
    }

}

