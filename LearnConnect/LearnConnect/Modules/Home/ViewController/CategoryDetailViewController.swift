import UIKit

class CategoryDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let category: BannerItem
    private var videos: [Video] = []
    private let networkManager = NetworkManager.shared
    
    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
    
    // MARK: - Init
    init(category: BannerItem) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchVideos()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(dismissButton)
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        
        titleLabel.text = category.title
        
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dismissButton.widthAnchor.constraint(equalToConstant: 32),
            dismissButton.heightAnchor.constraint(equalToConstant: 32),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: dismissButton.leadingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func fetchVideos() {
        networkManager.searchVideos(query: category.title) { [weak self] result in
            switch result {
            case .success(let videos):
                self?.videos = videos
                self?.collectionView.reloadData()
            case .failure(let error):
                print("Error fetching videos: \(error)")
            }
        }
    }
    
    // MARK: - Actions
    @objc private func dismissButtonTapped() {
        dismiss(animated: true)
    }
    
    // Video oynatma metodunu sınıfın içine taşıyalım
    private func playVideo(_ video: Video) {
        let videoId = video.id.videoId
        if let youtubeURL = URL(string: "youtube://\(videoId)"),
           UIApplication.shared.canOpenURL(youtubeURL) {
            // YouTube uygulaması yüklüyse onu aç
            UIApplication.shared.open(youtubeURL)
        } else if let webURL = URL(string: "https://www.youtube.com/watch?v=\(videoId)") {
            // YouTube uygulaması yoksa web'de aç
            let videoPlayerVC = VideoPlayerViewController(videoURL: webURL)
            videoPlayerVC.modalPresentationStyle = .fullScreen
            present(videoPlayerVC, animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegate & DataSource
extension CategoryDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CourseCollectionViewCell.identifier, for: indexPath) as! CourseCollectionViewCell
        cell.configure(with: videos[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 10) / 2 // 2 sütun, 10pt boşluk
        return CGSize(width: width, height: width * 1.4) // 1.4 aspect ratio
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = videos[indexPath.item]
        playVideo(video)
    }
} 