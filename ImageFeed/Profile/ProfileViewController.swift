import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let tokenStorage = OAuthTokenStorage()
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private lazy var imageView: UIImageView = {
        let image = UIImage(named: "placeholderImage")
        let imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        nameLabel.textColor = .white
        return nameLabel
    }()

    private lazy var nickNameLabel: UILabel = {
        let nickNameLabel = UILabel()
        nickNameLabel.font = .systemFont(ofSize: 13)
        nickNameLabel.textColor = UIColor(named: "YP Gray")
        return nickNameLabel
    }()

    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.textColor = .white
        return descriptionLabel
    }()

    private lazy var exitButton: UIButton = {
        guard let buttonImage = UIImage(systemName: "ipad.and.arrow.forward") else { return UIButton() }
        let button = UIButton.systemButton(
            with: buttonImage,
            target: self,
            action: #selector(exitButtonClicked)
        )
        button.tintColor = UIColor(named: "YP Red")
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "YP Black")
        setupConstraints()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
        
        guard let profileData = profileService.profile else { return }
        updateLabels(profileData)
    }
    
    @objc
    private func exitButtonClicked() {
        let alertModel = AlertModel(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            buttons: [
                .init(title: "Да", completion: logout),
                .init(title: "Нет", completion: nil),
            ]
        )
        let presenter = AlertPresenter(model: alertModel, delegate: self)
        presenter.present()
    }
    
    private func logout() {
        ProfileLogoutService.shared.logout()
        guard let window = UIApplication.shared.windows.first else { return }
        window.rootViewController = SplashViewController()
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarUrl,
            let url = URL(string: profileImageURL)
        else { return }
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage")
        )
    }
    
    private func updateLabels(_ profile: Profile) {
        nameLabel.text = profile.name
        nickNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }

    private func setupConstraints() {
        [
            imageView,
            nameLabel,
            nickNameLabel,
            descriptionLabel,
            exitButton,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            
            nickNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            nickNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: nickNameLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: 8),
            
            exitButton.widthAnchor.constraint(equalToConstant: 44),
            exitButton.heightAnchor.constraint(equalToConstant: 44),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -14),
            exitButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
        ])
    }
}

