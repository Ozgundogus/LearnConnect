import UIKit

class ToastManager {
    static func showToast(message: String, in viewController: UIViewController, isError: Bool = false) {
        let toastContainer = UIView()
        toastContainer.backgroundColor = isError ? .systemRed : .systemGreen
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 25
        toastContainer.clipsToBounds = true
        
        let toastLabel = UILabel()
        toastLabel.textColor = UIColor.white
        toastLabel.text = message
        toastLabel.textAlignment = .center
        toastLabel.font = .systemFont(ofSize: 14, weight: .medium)
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 0
        
        viewController.view.addSubview(toastContainer)
        toastContainer.addSubview(toastLabel)
        
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            toastContainer.topAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            toastContainer.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 20),
            toastContainer.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -20),
            toastContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            toastLabel.topAnchor.constraint(equalTo: toastContainer.topAnchor, constant: 15),
            toastLabel.leadingAnchor.constraint(equalTo: toastContainer.leadingAnchor, constant: 15),
            toastLabel.trailingAnchor.constraint(equalTo: toastContainer.trailingAnchor, constant: -15),
            toastLabel.bottomAnchor.constraint(equalTo: toastContainer.bottomAnchor, constant: -15)
        ])
        
        toastContainer.transform = CGAffineTransform(translationX: 0, y: -200)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            toastContainer.alpha = 1.0
            toastContainer.transform = .identity
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 2.0, options: .curveEaseIn, animations: {
                toastContainer.alpha = 0.0
                toastContainer.transform = CGAffineTransform(translationX: 0, y: -200)
            }, completion: { _ in
                toastContainer.removeFromSuperview()
            })
        })
    }
} 