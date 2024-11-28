//
//  HomeViewController.swift
//  LearnConnect
//
//  Created by Ozgun Dogus on 24.11.2024.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search courses..."
        controller.hidesNavigationBarDuringPresentation = false
        controller.searchBar.delegate = self
        controller.isActive = false
        controller.definesPresentationContext = true
        return controller
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bannerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return collectionView
    }()
    
    private let categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 16)
        return collectionView
    }()
    
    private let coursesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return collectionView
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.backgroundColor = .systemGray5
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .systemGray2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let viewModel = HomeViewModel()
    

    private let commonCornerRadius: CGFloat = 12
    

    private struct BannerItem {
        let title: String
        let image: String
    }
    

    private let bannerItems: [BannerItem] = [
        BannerItem(title: "Sports", image: "Sports"),
        BannerItem(title: "Travel", image: "Travel"),
        BannerItem(title: "LifeStyle", image: "LifeStyle"),
        BannerItem(title: "Education", image: "Education"),
        BannerItem(title: "Nature", image: "Nature")
    ]
    
  
    private var notificationButton: UIBarButtonItem!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTheme()
        setupViewModel()
        setupUI()
        configureNavigationBar()
        setupCollectionViews()
        setupProfileImageObserver()
        loadProfileImage()
        
  
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
  
        navigationController?.navigationBar.isUserInteractionEnabled = true
        
   
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateBadgeCount(_:)),
            name: NSNotification.Name("BadgeCountDidChange"),
            object: nil
        )
    }
    
    override func themeDidChange(_ notification: Notification) {
        super.themeDidChange(notification)
        guard let theme = notification.object as? Theme else { return }
        
        
       
        bannerCollectionView.backgroundColor = theme.backgroundColor
        categoriesCollectionView.backgroundColor = theme.backgroundColor
        coursesCollectionView.backgroundColor = theme.backgroundColor
        

        bannerCollectionView.reloadData()
        categoriesCollectionView.reloadData()
        coursesCollectionView.reloadData()
    }
    
    // MARK: - Setup
    private func setupViewModel() {
        viewModel.delegate = self
        viewModel.fetchData()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        

        contentView.addSubview(bannerCollectionView)
        contentView.addSubview(categoriesCollectionView)
        contentView.addSubview(coursesCollectionView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            bannerCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bannerCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bannerCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bannerCollectionView.heightAnchor.constraint(equalToConstant: 180),
            
            categoriesCollectionView.topAnchor.constraint(equalTo: bannerCollectionView.bottomAnchor, constant: 16),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: 40),
            
            coursesCollectionView.topAnchor.constraint(equalTo: categoriesCollectionView.bottomAnchor, constant: 16),
            coursesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coursesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coursesCollectionView.heightAnchor.constraint(equalToConstant: 280),
            coursesCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "LearnConnect"
        
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .label
        
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
      
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 30),
            profileImageView.heightAnchor.constraint(equalToConstant: 30),
            profileImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 30),
            containerView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        let profileButton = UIBarButtonItem(customView: containerView)
        
      
        notificationButton = UIBarButtonItem(
            image: UIImage(systemName: "bell")?.withConfiguration(
                UIImage.SymbolConfiguration(weight: .medium)
            ),
            style: .plain,
            target: self,
            action: #selector(notificationButtonTapped)
        )
        notificationButton.tintColor = .label
        
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass")?.withConfiguration(UIImage.SymbolConfiguration(weight: .medium)), 
                                         style: .plain, 
                                         target: self, 
                                         action: #selector(searchButtonTapped))
        searchButton.tintColor = .label
        
        navigationItem.leftBarButtonItem = profileButton
        navigationItem.rightBarButtonItems = [notificationButton, searchButton]
        
       
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func setupCollectionViews() {
        
        bannerCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "BannerCell")
        categoriesCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        coursesCollectionView.register(CourseCollectionViewCell.self, forCellWithReuseIdentifier: CourseCollectionViewCell.identifier)
        
      
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        coursesCollectionView.delegate = self
        coursesCollectionView.dataSource = self
    }
    
    // MARK: - Actions
    @objc private func searchButtonTapped() {
        searchController.isActive = true
        searchController.searchBar.becomeFirstResponder()
    }
    
    @objc private func notificationButtonTapped() {
        let notificationVC = NotificationViewController()
        let navController = UINavigationController(rootViewController: notificationVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
   
    private func playVideo(_ video: Video) {
        let videoId = video.id.videoId
        if let youtubeURL = URL(string: "youtube://\(videoId)"),
           UIApplication.shared.canOpenURL(youtubeURL) {
            
            UIApplication.shared.open(youtubeURL)
        } else if let webURL = URL(string: "https://www.youtube.com/watch?v=\(videoId)") {
            
            let videoPlayerVC = VideoPlayerViewController(videoURL: webURL)
            videoPlayerVC.modalPresentationStyle = .fullScreen
            present(videoPlayerVC, animated: true)
        }
    }
    
    private func setupProfileImageObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(profileImageDidChange(_:)),
            name: NSNotification.Name("ProfileImageDidChange"),
            object: nil
        )
    }
    
    @objc private func profileImageDidChange(_ notification: Notification) {
        if let imageData = notification.object as? Data,
           let updatedImage = UIImage(data: imageData) {
            profileImageView.image = updatedImage
        }
    }
    
    private func loadProfileImage() {
        if let imageData = UserDefaults.standard.data(forKey: "userProfileImage"),
           let savedImage = UIImage(data: imageData) {
            profileImageView.image = savedImage
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
  
    @objc private func updateBadgeCount(_ notification: Notification) {
        if let count = notification.object as? Int {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                
                let imageName = count > 0 ? "bell.fill" : "bell"
                self.notificationButton.image = UIImage(
                    systemName: imageName
                )?.withConfiguration(
                    UIImage.SymbolConfiguration(weight: .medium)
                )
            }
        }
    }
}

// MARK: - HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
    func videosDidUpdate() {
        coursesCollectionView.reloadData()
    }
    
    func categoriesDidUpdate() {
        categoriesCollectionView.reloadData()
    }
    
    func didReceiveError(_ error: Error) {
       
        print("Error: \(error)")
    }
}

// MARK: - UICollectionViewDelegate & DataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoriesCollectionView {
            return viewModel.categories.count
        } else if collectionView == bannerCollectionView {
            return viewModel.bannerItems.count
        }
        return viewModel.videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoriesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath)
            let isSelected = viewModel.selectedCategoryIndex == indexPath.item
            
           
            let label = cell.viewWithTag(100) as? UILabel ?? {
                let label = UILabel()
                label.tag = 100
                label.textAlignment = .center
                label.font = .systemFont(ofSize: 14)
                label.translatesAutoresizingMaskIntoConstraints = false
                cell.addSubview(label)
                NSLayoutConstraint.activate([
                    label.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
                    label.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
                    label.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 16),
                    label.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -16)
                ])
                return label
            }()
            
            
            if isSelected {
                cell.backgroundColor = .systemBlue
                label.textColor = .white
                UIView.animate(withDuration: 0.2) {
                    cell.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                }
            } else {
                cell.backgroundColor = .systemGray4
                label.textColor = .white
                cell.transform = .identity
            }
            
            label.text = viewModel.categories[indexPath.item].snippet.title
            cell.layer.cornerRadius = commonCornerRadius
            return cell
            
        } else if collectionView == bannerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath)
            let bannerItem = viewModel.bannerItems[indexPath.item]
            
           
            let imageView = cell.viewWithTag(104) as? UIImageView ?? {
                let iv = UIImageView()
                iv.tag = 104
                iv.contentMode = .scaleAspectFill
                iv.clipsToBounds = true
                iv.translatesAutoresizingMaskIntoConstraints = false
                cell.addSubview(iv)
                NSLayoutConstraint.activate([
                    iv.topAnchor.constraint(equalTo: cell.topAnchor),
                    iv.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
                    iv.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
                    iv.bottomAnchor.constraint(equalTo: cell.bottomAnchor)
                ])
                return iv
            }()
            
           
            let gradientLayer = cell.layer.sublayers?.first as? CAGradientLayer ?? {
                let gradientLayer = CAGradientLayer()
                gradientLayer.colors = [
                    UIColor.clear.cgColor,
                    UIColor.black.withAlphaComponent(0.7).cgColor
                ]
                gradientLayer.locations = [0.0, 1.0]
                cell.layer.insertSublayer(gradientLayer, at: 0)
                return gradientLayer
            }()
            
           
            let label = cell.viewWithTag(103) as? UILabel ?? {
                let label = UILabel()
                label.tag = 103
                label.textAlignment = .center
                label.font = .systemFont(ofSize: 24, weight: .bold)
                label.textColor = .white
                label.translatesAutoresizingMaskIntoConstraints = false
                cell.addSubview(label)
                NSLayoutConstraint.activate([
                    label.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 16),
                    label.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -16),
                    label.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -16)
                ])
                return label
            }()
            
            
            imageView.image = UIImage(named: bannerItem.image)
            label.text = bannerItem.title
            gradientLayer.frame = cell.bounds
            
            cell.layer.cornerRadius = commonCornerRadius
            cell.clipsToBounds = true
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CourseCollectionViewCell.identifier, for: indexPath) as! CourseCollectionViewCell
            let video = viewModel.videos[indexPath.item]
            cell.delegate = self
            cell.configure(with: video)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == bannerCollectionView {
            let padding: CGFloat = 32
            let itemWidth = view.frame.width - padding
            return CGSize(width: itemWidth, height: 180)
        } else if collectionView == categoriesCollectionView {
            let category = viewModel.categories[indexPath.item]
            let label = UILabel()
            label.font = .systemFont(ofSize: 14)
            label.text = category.snippet.title
            let size = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 40))
            let width = size.width + 32
            return CGSize(width: width, height: 40)
        } else {
            return CGSize(width: 180, height: 280)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoriesCollectionView {
            
            if let oldCell = collectionView.cellForItem(at: IndexPath(item: viewModel.selectedCategoryIndex, section: 0)) {
                oldCell.backgroundColor = .systemGray6
                if let label = oldCell.viewWithTag(100) as? UILabel {
                    label.textColor = .white
                }
                oldCell.transform = .identity
            }
            
            
            if let newCell = collectionView.cellForItem(at: indexPath) {
                newCell.backgroundColor = .systemBlue
                if let label = newCell.viewWithTag(100) as? UILabel {
                    label.textColor = .white
                }
                UIView.animate(withDuration: 0.2) {
                    newCell.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                }
            }
            
            
            viewModel.selectCategory(at: indexPath.item)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else if collectionView == bannerCollectionView {
            let category = viewModel.bannerItems[indexPath.item]
            let detailVC = CategoryDetailViewController(category: category)
            detailVC.modalPresentationStyle = .pageSheet
            
            if let sheet = detailVC.sheetPresentationController {
                sheet.detents = [.large()]
                sheet.prefersGrabberVisible = true
            }
            
            present(detailVC, animated: true)
        } else if collectionView == coursesCollectionView {
            let video = viewModel.videos[indexPath.item]
            playVideo(video)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == categoriesCollectionView {
            return 6
        } else if collectionView == coursesCollectionView {
            return 10
        }
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == bannerCollectionView {
            return .zero
        } else if collectionView == coursesCollectionView {
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        return .zero
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView == bannerCollectionView else { return }
        
        let itemWidth = view.frame.width - 32 // Banner genişliği
        let targetX = scrollView.contentOffset.x + velocity.x * 200
        
        let nearestPage = round(targetX / itemWidth)
        let xOffset = nearestPage * itemWidth
        
        
        let inset = (scrollView.frame.width - itemWidth) / 2
        targetContentOffset.pointee = CGPoint(x: xOffset - inset, y: 0)
    }
}

// MARK: - UISearchResultsUpdating & UISearchBarDelegate
extension HomeViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(performSearch(_:)), object: nil)
        perform(#selector(performSearch(_:)), with: searchText, afterDelay: 0.5)
    }
    
    @objc private func performSearch(_ searchText: String) {
        viewModel.searchVideos(with: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        viewModel.searchVideos(with: "")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            viewModel.searchVideos(with: searchText)
        }
        searchController.isActive = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
      
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
       
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}

// MARK: - CourseCollectionViewCellDelegate
extension HomeViewController: CourseCollectionViewCellDelegate {
    func didTapBookmark(for cell: CourseCollectionViewCell) {
        if let indexPath = coursesCollectionView.indexPath(for: cell) {
            let video = viewModel.videos[indexPath.item]
            CoreDataManager.shared.saveBookmarkedVideo(
                title: video.snippet.title,
                videoUrl: "https://www.youtube.com/watch?v=\(video.id.videoId)",
                thumbnailUrl: video.snippet.thumbnails.high.url
            )
            
            cell.configure(with: video, isBookmarked: true)
        }
    }
    
    func didTapDownload(for cell: CourseCollectionViewCell) {
        if let indexPath = coursesCollectionView.indexPath(for: cell) {
            let video = viewModel.videos[indexPath.item]
            CoreDataManager.shared.saveSavedVideo(
                title: video.snippet.title,
                videoUrl: "https://www.youtube.com/watch?v=\(video.id.videoId)",
                thumbnailUrl: video.snippet.thumbnails.high.url,
                isDownloaded: true
            )
          
            ToastManager.showToast(message: "Videoyu başarıyla indirdiniz", in: self)
        }
    }
    
    func didTapPlay(for cell: CourseCollectionViewCell) {
        if let indexPath = coursesCollectionView.indexPath(for: cell) {
            let video = viewModel.videos[indexPath.item]
            playVideo(video)
        }
    }
}


