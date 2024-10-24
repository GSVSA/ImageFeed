import UIKit

final class ProfileViewController: UIViewController {
    private let imageView: UIImageView = {
        let image = UIImage(named: "profilePhoto")
        let imageView = UIImageView(image: image)
        return imageView
    }()

    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        nameLabel.textColor = .white
        return nameLabel
    }()

    private let nickNameLabel: UILabel = {
        let nickNameLabel = UILabel()
        nickNameLabel.text = "@ekaterina_nov"
        nickNameLabel.font = .systemFont(ofSize: 13)
        nickNameLabel.textColor = UIColor(named: "YP Gray")
        return nickNameLabel
    }()

    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.textColor = .white
        return descriptionLabel
    }()

    private let exitButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: ProfileViewController.self,
            action: nil
        )
        button.tintColor = UIColor(named: "YP Red")
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
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

