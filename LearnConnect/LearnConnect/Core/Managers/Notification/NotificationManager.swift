import UserNotifications
import UIKit

class NotificationManager: NSObject {
    static let shared = NotificationManager()
    
    private let notificationMessages = [
        "Spor kategorisindeki kursları incelemek ister misiniz?",
        "Eğitim kategorisindeki kursları incelemek ister misiniz?",
        "Doğa kategorisindeki kursları incelemek ister misiniz?",
        "Gezi kategorisindeki kursları incelemek ister misiniz?",
        "LifeStyle kategorisindeki kursları incelemek ister misiniz?"
    ]
    
    private var currentMessageIndex = 0
    private var badgeNumber = 0
    
    private(set) var activeNotifications: [String] = []
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                self.scheduleNotifications()
            }
        }
    }
    
    private func scheduleNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let interval: TimeInterval = 180
        
        for i in 0..<5 {
            let content = UNMutableNotificationContent()
            content.title = "LearnConnect"
            content.body = notificationMessages[i]
            content.sound = .default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval * Double(i + 1), repeats: false)
            let request = UNNotificationRequest(identifier: "notification-\(i)", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    func incrementBadge() {
        badgeNumber += 1
        updateBadge()
    }
    
    func resetBadge() {
        badgeNumber = 0
        updateBadge()
    }
    
    private func updateBadge() {
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = self.badgeNumber
           
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: NSNotification.Name("BadgeCountDidChange"),
                    object: self.badgeNumber
                )
            }
        }
    }
    
    func getBadgeCount() -> Int {
        return badgeNumber
    }
    
    private func addNotification(_ message: String) {
        activeNotifications.insert(message, at: 0) // En yeni bildirimi başa ekle
        NotificationCenter.default.post(name: NSNotification.Name("NotificationsDidUpdate"), object: nil)
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        incrementBadge()
        addNotification(notification.request.content.body)
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            let notificationVC = NotificationViewController()
            let navController = UINavigationController(rootViewController: notificationVC)
            rootViewController.present(navController, animated: true)
        }
        completionHandler()
    }
} 
