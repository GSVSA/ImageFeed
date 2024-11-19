import UIKit

final class SplashViewController: UIViewController {
    private let profileService = ProfileService.shared
    private let oAuthStorage = OAuthTokenStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if oAuthStorage.isAuthorized {
            fetchProfile()
        } else {
            showNavigationController()
        }
    }
    
    private func configUI() {
        view.backgroundColor = UIColor(named: "YP Black")
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            imageView.widthAnchor.constraint(equalToConstant: 75),
            imageView.heightAnchor.constraint(equalToConstant: 78)
        ])
    }
    
    private func showTabBarController() {
        let tabBarController = TabBarController()
        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: true)
    }
    
    private func showNavigationController() {
        let authViewController = AuthViewController()
        authViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: authViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: false)
    }
    
    private func fetchProfile() {
        guard let token = oAuthStorage.token else {
            assertionFailure("Failed to get OAuth Token")
            return
        }
        
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            
            switch result {
            case .success(let profileData):
                ProfileImageService.shared.fetchProfileImageURL(username: profileData.username) { _ in }
                self.showTabBarController()
            case .failure:
                break
            }
        }
    }
}

// MARK: - extensions

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
    }
}
