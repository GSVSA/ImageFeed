import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet private var backgroundLabel: UIView!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    private func applyGradient() {
        let gradientLayer = CAGradientLayer()

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
    
    private func configUI() {
        backgroundLabel.layer.cornerRadius = 16
        backgroundLabel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        applyGradient()
    }

}
