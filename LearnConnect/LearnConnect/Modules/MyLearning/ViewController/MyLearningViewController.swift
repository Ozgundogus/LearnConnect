import UIKit

class MyLearningViewController: UIViewController {
    private var downloadedVideos: [SavedVideo] = []
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDownloadedVideos()
    }
    
    private func setupUI() {
        title = "My Learning"
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadDownloadedVideos() {
        downloadedVideos = CoreDataManager.shared.fetchDownloadedVideos()
        collectionView.reloadData()
    }
    
    private func playVideo(_ video: SavedVideo) {
        if let videoURL = video.videoUrl {
            let videoId = videoURL.components(separatedBy: "=").last ?? ""
            if let youtubeURL = URL(string: "youtube://\(videoId)"),
               UIApplication.shared.canOpenURL(youtubeURL) {
                // YouTube uygulaması yüklüyse onu aç
                UIApplication.shared.open(youtubeURL)
            } else if let webURL = URL(string: videoURL) {
                // YouTube uygulaması yoksa web'de aç
                let videoPlayerVC = VideoPlayerViewController(videoURL: webURL)
                videoPlayerVC.modalPresentationStyle = .fullScreen
                present(videoPlayerVC, animated: true)
            }
        }
    }
}

extension MyLearningViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return downloadedVideos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CourseCollectionViewCell.identifier, for: indexPath) as! CourseCollectionViewCell
        let video = downloadedVideos[indexPath.item]
        cell.delegate = self
        
        // Configure cell with downloaded video
        if let videoURL = video.videoUrl, let thumbnailURL = video.thumbnailUrl {
            let videoId = videoURL.components(separatedBy: "=").last ?? ""
            
            // Create decoder and container for Video initialization
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
                cell.configure(with: videoStruct)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 10) / 2 // 2 columns with 10pt spacing
        return CGSize(width: width, height: width * 1.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = downloadedVideos[indexPath.item]
        playVideo(video)
    }
}

// MARK: - CourseCollectionViewCellDelegate
extension MyLearningViewController: CourseCollectionViewCellDelegate {
    func didTapBookmark(for cell: CourseCollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            let video = downloadedVideos[indexPath.item]
            if let videoURL = video.videoUrl {
                CoreDataManager.shared.saveBookmarkedVideo(
                    title: video.title ?? "",
                    videoUrl: videoURL,
                    thumbnailUrl: video.thumbnailUrl
                )
            }
        }
    }
    
    func didTapDownload(for cell: CourseCollectionViewCell) {
        // Already downloaded
    }
    
    func didTapPlay(for cell: CourseCollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            let video = downloadedVideos[indexPath.item]
            playVideo(video)
        }
    }
} 
