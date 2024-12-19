import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    private lazy var cellImage = UIImageView()
    private lazy var gradientLayer = CAGradientLayer()
    private lazy var backgroundLabel = UIView()

    private lazy var favoritesButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "favoritesNoActive"), for: .normal)
        button.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        button.accessibilityIdentifier = Identifiers.imagesCellFavoriteButton
        return button
    }()
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        configUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = backgroundLabel.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    func setImageURL(_ imageURL: URL, completion: @Sendable @escaping (Result<RetrieveImageResult, KingfisherError>) -> Void) {
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(
            with: imageURL,
            placeholder: UIImage(named: "stubImage"),
            options: [],
            completionHandler: completion
        )
            
    }
    
    func setDateLabel(_ dateString: String) {
        dateLabel.text = dateString
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let likeImage = isLiked
            ? UIImage(named: "favoritesActive")
            : UIImage(named: "favoritesNoActive")
        favoritesButton.setImage(likeImage, for: .normal)
    }
    
    @objc
    private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    private func configUI() {
        self.backgroundColor = UIColor(named: "YP Black")
        self.contentView.backgroundColor = UIColor(named: "YP Black")
        cellImage.layer.cornerRadius = 16
        cellImage.layer.masksToBounds = true
        backgroundLabel.layer.cornerRadius = 16
        backgroundLabel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        applyGradient()
    }
    
    private func applyGradient() {
        gradientLayer.frame = backgroundLabel.bounds
        gradientLayer.colors = [
            (UIColor(named: "YP Black") ?? UIColor.black).withAlphaComponent(0).cgColor,
            (UIColor(named: "YP Black") ?? UIColor.black).withAlphaComponent(0.2).cgColor,
        ]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        backgroundLabel.layer.addSublayer(gradientLayer)
    }
    
    private func setupConstraints() {
        [
            cellImage,
            favoritesButton,
            backgroundLabel,
            dateLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            cellImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            cellImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            cellImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            cellImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            
            favoritesButton.widthAnchor.constraint(equalToConstant: 44),
            favoritesButton.heightAnchor.constraint(equalTo: favoritesButton.widthAnchor),
            favoritesButton.topAnchor.constraint(equalTo: cellImage.topAnchor),
            favoritesButton.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            
            backgroundLabel.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor),
            backgroundLabel.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            backgroundLabel.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor),
            
            dateLabel.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(greaterThanOrEqualTo: cellImage.leadingAnchor, constant: -8),
            dateLabel.topAnchor.constraint(equalTo: backgroundLabel.topAnchor, constant: 4),
            dateLabel.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor, constant: -8),
        ])
    }
}
