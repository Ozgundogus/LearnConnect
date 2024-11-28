import Foundation
import CoreData

class AuthManager {
    static let shared = AuthManager()
    private init() {}
    
    func signUp(username: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        // Check if user already exists
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@ OR email == %@", username, email)
        
        do {
            let existingUsers = try context.fetch(fetchRequest)
            if !existingUsers.isEmpty {
                completion(false)
                return
            }
            
            // Create new user
            let user = User(context: context)
            user.username = username
            user.email = email
            user.password = password
            
            try context.save()
            completion(true)
        } catch {
            print("Error: \(error)")
            completion(false)
        }
    }
    
    func signIn(username: String, password: String, completion: @escaping (Bool) -> Void) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)
        
        do {
            let users = try context.fetch(fetchRequest)
            completion(!users.isEmpty)
        } catch {
            print("Error: \(error)")
            completion(false)
        }
    }
} 