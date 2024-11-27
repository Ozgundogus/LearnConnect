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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Find a course you\nwant to learn."
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 28, weight: .bold)
        return label
    }()
    
    private let bannerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = false
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
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return collectionView
    }()
    
    private let learnFlexLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "LearnFlex"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let seeAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("See All", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        return button
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
        imageView.backgroundColor = .systemGray5 // Placeholder background
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .systemGray2
        return imageView
    }()
    
    private let viewModel = HomeViewModel()
    
    // Önce ortak corner radius değeri tanımlayalım
    private let commonCornerRadius: CGFloat = 12
    
    // Banner için model oluşturalım
    private struct BannerItem {
        let title: String
        let image: String
    }
    
    // Banner verilerini güncelleyelim
    private let bannerItems: [BannerItem] = [
        BannerItem(title: "Sports", image: "Sports"),
        BannerItem(title: "Travel", image: "Travel"),
        BannerItem(title: "LifeStyle", image: "LifeStyle"),
        BannerItem(title: "Education", image: "Education"),
        BannerItem(title: "Nature", image: "Nature")
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTheme()
        setupViewModel()
        setupUI()
        configureNavigationBar()
        setupCollectionViews()
    }
    
    override func themeDidChange(_ notification: Notification) {
        super.themeDidChange(notification)
        guard let theme = notification.object as? Theme else { return }
        
        // Update UI elements
        titleLabel.textColor = theme.textColor
        learnFlexLabel.textColor = theme.textColor
        seeAllButton.tintColor = theme.secondaryTextColor
        
        // Update collection views
        bannerCollectionView.backgroundColor = theme.backgroundColor
        categoriesCollectionView.backgroundColor = theme.backgroundColor
        coursesCollectionView.backgroundColor = theme.backgroundColor
        
        // Reload collection views to update cell appearances
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
        
        // Add scrollView
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Add subviews to contentView
        contentView.addSubview(titleLabel)
        contentView.addSubview(bannerCollectionView)
        contentView.addSubview(categoriesCollectionView)
        contentView.addSubview(learnFlexLabel)
        contentView.addSubview(seeAllButton)
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
            
            titleLabel.topAnchor.constraint(equalTo: coursesCollectionView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            learnFlexLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            learnFlexLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            seeAllButton.centerYAnchor.constraint(equalTo: learnFlexLabel.centerYAnchor),
            seeAllButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            learnFlexLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "LearnConnect"
        
        // Configure navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        // Setup profile image view
        profileImageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let profileButton = UIBarButtonItem(customView: profileImageView)
        
        // Add right bar button items
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
        let notificationButton = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: #selector(notificationButtonTapped))
        
        navigationItem.leftBarButtonItem = profileButton
        navigationItem.rightBarButtonItems = [notificationButton, searchButton]
        
        // Setup search controller
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
    }
    
    private func setupCollectionViews() {
        // Register cells
        bannerCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "BannerCell")
        categoriesCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        coursesCollectionView.register(CourseCollectionViewCell.self, forCellWithReuseIdentifier: CourseCollectionViewCell.identifier)
        
        // Set delegates
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        coursesCollectionView.delegate = self
        coursesCollectionView.dataSource = self
    }
    
    // MARK: - Actions
    @objc private func searchButtonTapped() {
        navigationItem.searchController?.isActive = true
    }
    
    @objc private func notificationButtonTapped() {
        // Bildirim işlemleri için gerekli kodlar buraya eklenecek
        print("Notification button tapped")
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

// MARK: - HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
    func videosDidUpdate() {
        coursesCollectionView.reloadData()
    }
    
    func categoriesDidUpdate() {
        categoriesCollectionView.reloadData()
    }
    
    func didReceiveError(_ error: Error) {
        // Burada hata durumunda kullanıcıya alert gösterebilirsiniz
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
            
            // Add label for category name
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
            
            // Seçili duruma göre renkleri ayarla
            if isSelected {
                cell.backgroundColor = .systemBlue
                label.textColor = .white
                UIView.animate(withDuration: 0.2) {
                    cell.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                }
            } else {
                cell.backgroundColor = .systemGray6
                label.textColor = .white
                cell.transform = .identity
            }
            
            label.text = viewModel.categories[indexPath.item].snippet.title
            cell.layer.cornerRadius = commonCornerRadius
            return cell
            
        } else if collectionView == bannerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath)
            let bannerItem = viewModel.bannerItems[indexPath.item]
            
            // Banner image view
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
            
            // Banner için gradient
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
            
            // Banner başlık
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
            
            // İçeriği güncelle
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
            let padding: CGFloat = 32 // Sol ve sağ padding toplamı
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
            // Önceki seçili hücreyi bul ve normal haline getir
            if let oldCell = collectionView.cellForItem(at: IndexPath(item: viewModel.selectedCategoryIndex, section: 0)) {
                oldCell.backgroundColor = .systemGray6
                if let label = oldCell.viewWithTag(100) as? UILabel {
                    label.textColor = .white
                }
                oldCell.transform = .identity
            }
            
            // Yeni seçilen hücreyi güncelle
            if let newCell = collectionView.cellForItem(at: indexPath) {
                newCell.backgroundColor = .systemBlue
                if let label = newCell.viewWithTag(100) as? UILabel {
                    label.textColor = .white
                }
                UIView.animate(withDuration: 0.2) {
                    newCell.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                }
            }
            
            // ViewModel'i güncelle ve seçilen kategoriye scroll yap
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
            return 6 // Kategoriler arası boşluğu azalttık
        } else if collectionView == coursesCollectionView {
            return 10 // Course hücreleri arası boşluk
        }
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == bannerCollectionView {
            return .zero // Banner için section inset'leri kaldır, contentInset kullanıyoruz
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
        
        // Öğeyi ortala
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
        viewModel.searchVideos(with: "") // Aramayı temizle ve normal videoları göster
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            viewModel.searchVideos(with: searchText)
        }
        searchController.isActive = false
    }
}

// MARK: - CourseCollectionViewCellDelegate
extension HomeViewController: CourseCollectionViewCellDelegate {
    func didTapBookmark(for cell: CourseCollectionViewCell) {
        if let indexPath = coursesCollectionView.indexPath(for: cell) {
            // Bookmark işlemlerini burada yapabilirsiniz
            print("Bookmark tapped for video at index: \(indexPath.item)")
        }
    }
    
    func didTapDownload(for cell: CourseCollectionViewCell) {
        if let indexPath = coursesCollectionView.indexPath(for: cell) {
            // Download işlemlerini burada yapabilirsiniz
            print("Download tapped for video at index: \(indexPath.item)")
        }
    }
}


