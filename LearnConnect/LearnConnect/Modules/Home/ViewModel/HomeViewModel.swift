import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func videosDidUpdate()
    func categoriesDidUpdate()
    func didReceiveError(_ error: Error)
}

class HomeViewModel {
    // MARK: - Properties
    private let networkManager = NetworkManager.shared
    weak var delegate: HomeViewModelDelegate?
    
    private(set) var videos: [Video] = [] {
        didSet {
            delegate?.videosDidUpdate()
        }
    }
    
    private(set) var categories: [Category] = [] {
        didSet {
            delegate?.categoriesDidUpdate()
        }
    }
    
    private(set) var selectedCategoryIndex = 0
    
    let bannerItems: [BannerItem] = [
        BannerItem(title: "Sports", image: "Sports"),
        BannerItem(title: "Travel", image: "Travel"),
        BannerItem(title: "LifeStyle", image: "LifeStyle"),
        BannerItem(title: "Education", image: "Education"),
        BannerItem(title: "Nature", image: "Nature")
    ]
    
    private var searchText: String = ""
    
    // MARK: - Methods
    func fetchData() {
        fetchCategories()
        fetchVideos()
    }
    
    func searchVideos(with query: String) {
        searchText = query
        if query.isEmpty {
            fetchVideos() 
            return
        }
        
        networkManager.searchVideos(query: query) { [weak self] result in
            switch result {
            case .success(let videos):
                self?.videos = videos
            case .failure(let error):
                self?.delegate?.didReceiveError(error)
            }
        }
    }
    
    func selectCategory(at index: Int) {
        selectedCategoryIndex = index
        let selectedCategory = categories[index]
        
        print("Selected Category: \(selectedCategory.snippet.title), ID: \(selectedCategory.id)")
        
        networkManager.searchVideos(query: "", categoryId: selectedCategory.id) { [weak self] result in
            switch result {
            case .success(let videos):
                print("Received \(videos.count) videos for category: \(selectedCategory.snippet.title)")
                self?.videos = videos
            case .failure(let error):
                print("Error fetching videos for category \(selectedCategory.snippet.title): \(error)")
                self?.delegate?.didReceiveError(error)
            }
        }
    }
    
    private func fetchCategories() {
        networkManager.fetchVideoCategories { [weak self] result in
            switch result {
            case .success(let categories):
                self?.categories = categories
            case .failure(let error):
                self?.delegate?.didReceiveError(error)
            }
        }
    }
    
    private func fetchVideos() {
        networkManager.fetchTrendingVideos { [weak self] result in
            switch result {
            case .success(let videos):
                self?.videos = videos
            case .failure(let error):
                self?.delegate?.didReceiveError(error)
            }
        }
    }
}

// MARK: - Models
struct BannerItem {
    let title: String
    let image: String
} 
