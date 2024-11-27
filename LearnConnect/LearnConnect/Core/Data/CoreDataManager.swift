import CoreData
import Foundation

class CoreDataManager {
    // Singleton instance
    static let shared = CoreDataManager()

    // Persistent container setup
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LearnConnect") // Core Data model adını yazın
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()

    // Context for Core Data operations
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // Save changes to the context
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - SavedVideo Operations

    // Fetch all saved videos
    func fetchSavedVideos() -> [SavedVideo] {
        let fetchRequest: NSFetchRequest<SavedVideo> = SavedVideo.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching SavedVideos: \(error)")
            return []
        }
    }

    // Fetch only downloaded videos
    func fetchDownloadedVideos() -> [SavedVideo] {
        let fetchRequest: NSFetchRequest<SavedVideo> = SavedVideo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isDownloaded == true")
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching downloaded videos: \(error)")
            return []
        }
    }

    // Save a new video
    func saveSavedVideo(title: String, videoUrl: String, thumbnailUrl: String? = nil, isDownloaded: Bool = false) {
        let savedVideo = SavedVideo(context: context)
        savedVideo.title = title
        savedVideo.videoUrl = videoUrl
        savedVideo.thumbnailUrl = thumbnailUrl
        savedVideo.isDownloaded = isDownloaded
        savedVideo.downloadDate = isDownloaded ? Date() : nil

        saveContext()
    }

    // Delete a saved video
    func deleteSavedVideo(_ video: SavedVideo) {
        context.delete(video)
        saveContext()
    }

    // MARK: - BookmarkedVideo Operations

    // Fetch all bookmarked videos
    func fetchBookmarkedVideos() -> [BookmarkedVideo] {
        let fetchRequest: NSFetchRequest<BookmarkedVideo> = BookmarkedVideo.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching BookmarkedVideos: \(error)")
            return []
        }
    }

    // Save a new bookmarked video
    func saveBookmarkedVideo(title: String, videoUrl: String, thumbnailUrl: String? = nil) {
        let bookmarkedVideo = BookmarkedVideo(context: context)
        bookmarkedVideo.title = title
        bookmarkedVideo.videoUrl = videoUrl
        bookmarkedVideo.thumbnailUrl = thumbnailUrl
        bookmarkedVideo.bookmarkDate = Date()

        saveContext()
    }

    // Delete a bookmarked video
    func deleteBookmarkedVideo(_ video: BookmarkedVideo) {
        context.delete(video)
        saveContext()
    }
}

