import CoreData
import Foundation

class CoreDataManager {
   
    static let shared = CoreDataManager()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LearnConnect")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

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

    func fetchSavedVideos() -> [SavedVideo] {
        let fetchRequest: NSFetchRequest<SavedVideo> = SavedVideo.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching SavedVideos: \(error)")
            return []
        }
    }

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

    func saveSavedVideo(title: String, videoUrl: String, thumbnailUrl: String? = nil, isDownloaded: Bool = false) {
        let savedVideo = SavedVideo(context: context)
        savedVideo.title = title
        savedVideo.videoUrl = videoUrl
        savedVideo.thumbnailUrl = thumbnailUrl
        savedVideo.isDownloaded = isDownloaded
        savedVideo.downloadDate = isDownloaded ? Date() : nil

        saveContext()
    }

    func deleteSavedVideo(_ video: SavedVideo) {
        context.delete(video)
        saveContext()
    }

    // MARK: - BookmarkedVideo Operations

    func fetchBookmarkedVideos() -> [BookmarkedVideo] {
        let fetchRequest: NSFetchRequest<BookmarkedVideo> = BookmarkedVideo.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching BookmarkedVideos: \(error)")
            return []
        }
    }

    func saveBookmarkedVideo(title: String, videoUrl: String, thumbnailUrl: String? = nil) {
        let bookmarkedVideo = BookmarkedVideo(context: context)
        bookmarkedVideo.title = title
        bookmarkedVideo.videoUrl = videoUrl
        bookmarkedVideo.thumbnailUrl = thumbnailUrl
        bookmarkedVideo.bookmarkDate = Date()

        saveContext()
    }

    func deleteBookmarkedVideo(_ video: BookmarkedVideo) {
        context.delete(video)
        saveContext()
    }
}

