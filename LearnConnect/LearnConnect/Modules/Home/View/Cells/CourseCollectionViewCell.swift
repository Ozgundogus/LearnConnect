import UIKit

protocol CourseCollectionViewCellDelegate: AnyObject {
    func didTapBookmark(for cell: CourseCollectionViewCell)
    func didTapDownload(for cell: CourseCollectionViewCell)
}

class CourseCollectionViewCell: UICollectionViewCell {
    static let identifier = "CourseCell"
    
    weak var delegate: CourseCollectionViewCellDelegate?
    private var isBookmarked = false
    
    // MARK: - UI Elements
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let playButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .medium)
        let image = UIImage(systemName: "play.circle.fill", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0.9
        return button
    }()
    
    private let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        let image = UIImage(systemName: "bookmark", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        button.layer.cornerRadius = 15
        return button
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        let image = UIImage(systemName: "arrow.down.circle", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        button.layer.cornerRadius = 15
        return button
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 12
        clipsToBounds = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playButton)
        contentView.addSubview(bookmarkButton)
        contentView.addSubview(downloadButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            playButton.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 50),
            playButton.heightAnchor.constraint(equalToConstant: 50),
            
            bookmarkButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8),
            bookmarkButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 30),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 30),
            
            downloadButton.topAnchor.constraint(equalTo: bookmarkButton.bottomAnchor, constant: 8),
            downloadButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
            downloadButton.widthAnchor.constraint(equalToConstant: 30),
            downloadButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        bookmarkButton.addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)
        downloadButton.addTarget(self, action: #selector(downloadTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func bookmarkTapped() {
        isBookmarked.toggle()
        updateBookmarkIcon()
        delegate?.didTapBookmark(for: self)
    }
    
    @objc private func downloadTapped() {
        delegate?.didTapDownload(for: self)
    }
    
    private func updateBookmarkIcon() {
        let imageName = isBookmarked ? "bookmark.fill" : "bookmark"
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        let image = UIImage(systemName: imageName, withConfiguration: config)
        bookmarkButton.setImage(image, for: .normal)
    }
    
    // MARK: - Configuration
    func configure(with video: Video, isBookmarked: Bool = false) {
        titleLabel.text = video.snippet.title
        self.isBookmarked = isBookmarked
        updateBookmarkIcon()
        
        if let thumbnailURL = URL(string: video.snippet.thumbnails.high.url) {
            URLSession.shared.dataTask(with: thumbnailURL) { [weak self] data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                }
            }.resume()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
        isBookmarked = false
        updateBookmarkIcon()
    }
} 