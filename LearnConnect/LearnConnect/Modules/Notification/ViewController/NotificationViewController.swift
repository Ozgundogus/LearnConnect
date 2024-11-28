import UIKit

class NotificationViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "NotificationCell")
        return table
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Şu anda bildirim bulunmamaktadır"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private var notifications: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNotificationObserver()
        updateNotifications()
        NotificationManager.shared.resetBadge()
    }
    
    private func setupUI() {
        title = "Bildirimler"
        view.backgroundColor = .systemBackground
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeButtonTapped)
        )
        
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(emptyStateLabel)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(notificationsDidUpdate),
            name: NSNotification.Name("NotificationsDidUpdate"),
            object: nil
        )
    }
    
    @objc private func notificationsDidUpdate() {
        updateNotifications()
    }
    
    private func updateNotifications() {
        notifications = NotificationManager.shared.activeNotifications
        tableView.reloadData()
        
        
        emptyStateLabel.isHidden = !notifications.isEmpty
        tableView.isHidden = notifications.isEmpty
    }
    
    private func loadNotifications() {
        updateNotifications()
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath)
        cell.textLabel?.text = notifications[indexPath.item]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
} 
