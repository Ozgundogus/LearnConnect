import UIKit

class BookmarkViewController: UIViewController {
    private var bookmarkedVideos: [BookmarkedVideo] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CourseCollectionViewCell.self, forCellWithReuseIdentifier: CourseCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Henüz bir videoyu bookmark olarak eklemediniz"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBookmarkedVideos()
    }
    
    private func setupUI() {
        title = "Bookmarks"
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        view.addSubview(emptyStateLabel)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func loadBookmarkedVideos() {
        bookmarkedVideos = CoreDataManager.shared.fetchBookmarkedVideos()
        collectionView.reloadData()
        
       
        emptyStateLabel.isHidden = !bookmarkedVideos.isEmpty
        collectionView.isHidden = bookmarkedVideos.isEmpty
    }
    
    private func playVideo(_ video: BookmarkedVideo) {
        if let videoURL = video.videoUrl {
            let videoId = videoURL.components(separatedBy: "=").last ?? ""
            if let youtubeURL = URL(string: "youtube://\(videoId)"),
               UIApplication.shared.canOpenURL(youtubeURL) {
                
                UIApplication.shared.open(youtubeURL)
            } else if let webURL = URL(string: videoURL) {
                
                let videoPlayerVC = VideoPlayerViewController(videoURL: webURL)
                videoPlayerVC.modalPresentationStyle = .fullScreen
                present(videoPlayerVC, animated: true)
            }
        }
    }
}

extension BookmarkViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookmarkedVideos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CourseCollectionViewCell.identifier, for: indexPath) as! CourseCollectionViewCell
        let video = bookmarkedVideos[indexPath.item]
        cell.delegate = self
        
        
        if let videoURL = video.videoUrl, let thumbnailURL = video.thumbnailUrl {
            let videoId = videoURL.components(separatedBy: "=").last ?? ""
            
           
            let snippet = VideoSnippet(
                title: video.title ?? "",
                description: "",
                thumbnails: Thumbnails(
                    medium: ThumbnailInfo(url: thumbnailURL, width: 320, height: 180),
                    high: ThumbnailInfo(url: thumbnailURL, width: 480, height: 360)
                ),
                channelTitle: "",
                publishedAt: "",
                categoryId: ""
            )
            
           
            let id = VideoID(videoId: videoId)
            
           
            let decoder = JSONDecoder()
            let data = try? JSONSerialization.data(withJSONObject: [
                "id": ["videoId": videoId],
                "snippet": [
                    "title": video.title ?? "",
                    "description": "",
                    "thumbnails": [
                        "medium": ["url": thumbnailURL, "width": 320, "height": 180],
                        "high": ["url": thumbnailURL, "width": 480, "height": 360]
                    ],
                    "channelTitle": "",
                    "publishedAt": "",
                    "categoryId": ""
                ]
            ])
            
            if let data = data,
               let videoStruct = try? decoder.decode(Video.self, from: data) {
                cell.configure(with: videoStruct, isBookmarked: true)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 10) / 2 // 2 columns with 10pt spacing
        return CGSize(width: width, height: width * 1.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = bookmarkedVideos[indexPath.item]
        playVideo(video)
    }
}

// MARK: - CourseCollectionViewCellDelegate
extension BookmarkViewController: CourseCollectionViewCellDelegate {
    func didTapBookmark(for cell: CourseCollectionViewCell) {
       
    }
    
    func didTapDownload(for cell: CourseCollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            let video = bookmarkedVideos[indexPath.item]
            if let videoURL = video.videoUrl {
                CoreDataManager.shared.saveSavedVideo(
                    title: video.title ?? "",
                    videoUrl: videoURL,
                    thumbnailUrl: video.thumbnailUrl,
                    isDownloaded: true
                )
                ToastManager.showToast(message: "Videoyu başarıyla indirdiniz", in: self)
            }
        }
    }
    
    func didTapPlay(for cell: CourseCollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            let video = bookmarkedVideos[indexPath.item]
            playVideo(video)
        }
    }
} 
