import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage? {
        didSet {
            guard isViewLoaded, let image else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    private lazy var imageView = UIImageView()
    private lazy var scrollView = UIScrollView()
    
    private lazy var returnButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "backward"), for: .normal)
        button.addTarget(self, action: #selector(didTabReturnButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "sharing"), for: .normal)
        button.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        button.backgroundColor = UIColor(named: "YP Black")
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        return button
    }()
    
//    func setImageURL(_ url: URL) {
//        imageView.kf.setImage(with: url, placeholder: UIImage(named: "stubImage"))
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        configUI()
    }
    
    private func configUI() {
        view.backgroundColor = UIColor(named: "YP Black")
        imageView.image = image
        imageView.frame.size = image?.size ?? CGSizeZero
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        setupConstraints()
        
        if let image {
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    private func setupConstraints() {
        [
            scrollView,
            returnButton,
            shareButton,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            returnButton.widthAnchor.constraint(equalToConstant: 44),
            returnButton.heightAnchor.constraint(equalTo: returnButton.widthAnchor),
            returnButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            returnButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            shareButton.widthAnchor.constraint(equalToConstant: 50),
            shareButton.heightAnchor.constraint(equalTo: shareButton.widthAnchor),
            shareButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }

    @objc
    private func didTabReturnButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc
    private func didTapShareButton(_ sender: UIButton) {
        guard let image else { return }
        let sharingController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(sharingController, animated: true)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale))) // 0.25125
        
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}


// MARK: - extensions

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let newContentSize = scrollView.contentSize
        let visibleRectSize = scrollView.bounds.size
        let x = (visibleRectSize.width - newContentSize.width) / 2
        let y = (visibleRectSize.height - newContentSize.height) / 2
        
        scrollView.contentInset = UIEdgeInsets(top: y, left: x, bottom: y, right: x)
    }
}
