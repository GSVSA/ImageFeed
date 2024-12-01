import UIKit

final class AuthViewController: UIViewController {
    weak var delegate: AuthViewControllerDelegate?
    
    private let oAuthService = OAuthService.shared
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logoUnsplash"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.backgroundColor = .white
        button.tintColor = UIColor(named: "YP Black")
        button.layer.cornerRadius = 16
        return button
    }()
    
    @objc
    private func loginAction() {
        let webViewViewController = WebViewViewController()
        webViewViewController.delegate = self
        navigationController?.pushViewController(webViewViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP Black")
        configureBackButton()
        setupConstraints()
    }
    
    private func setupConstraints() {
        [
            imageView,
            loginButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90)
        ])
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "backwardDark")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backwardDark")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black")
    }
}

// MARK: - extensions

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.navigationController?.popViewController(animated: true)
        
        UIBlockingProgressHUD.show()
        self.oAuthService.fetchOAuthToken(code: code) { result in
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success:
                self.delegate?.didAuthenticate(self)
            case .failure:
                self.showAlertError()
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.navigationController?.popViewController(animated: true)
    }
    
    private func showAlertError() {
        let presenter = AlertPresenter(message: "Не удалось войти в систему", delegate: self)
        presenter.present()
    }
}

