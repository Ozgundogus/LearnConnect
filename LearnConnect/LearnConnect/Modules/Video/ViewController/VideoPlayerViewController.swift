import UIKit
import WebKit
import YouTubeiOSPlayerHelper

class VideoPlayerViewController: UIViewController {
    
    private let videoID: String
    
    private lazy var playerView: YTPlayerView = {
        let player = YTPlayerView()
        player.translatesAutoresizingMaskIntoConstraints = false
        player.backgroundColor = .black
        return player
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(videoURL: URL) {
        self.videoID = Self.extractYouTubeID(from: videoURL) ?? ""
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadVideo()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(playerView)
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerView.heightAnchor.constraint(equalTo: playerView.widthAnchor, multiplier: 9.0/16.0),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
    }
    
    private func loadVideo() {
        let playerVars: [AnyHashable: Any] = [
            "playsinline": 1,
            "autoplay": 1,
            "controls": 1,
            "showinfo": 1,
            "rel": 0,
            "modestbranding": 1,
            "iv_load_policy": 3
        ]
        
        playerView.load(withVideoId: videoID, playerVars: playerVars)
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
    private static func extractYouTubeID(from url: URL) -> String? {
        if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems {
            return queryItems.first(where: { $0.name == "v" })?.value
        }
        return nil
    }
} 
