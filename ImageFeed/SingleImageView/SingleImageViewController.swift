import UIKit

final class SingleImageViewController: UIViewController {
    private lazy var imageView = UIImageView()
    private lazy var scrollView = UIScrollView()
    private var imageURL: URL?
    
    func setImageURL(_ url: URL) {
        imageURL = url
        loadImage()
    }
    
    private func loadImage() {
        guard let imageURL else { return }

        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: imageURL) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showError()
            }
        }
    }
    
    private func showError() {
        let alertModel = AlertModel(
            identifier: nil,
            title: "Что-то пошло не так. Попробовать ещё раз?",
            message: nil,
            buttons: [
                .init(title: "Не надо", completion: nil),
                .init(title: "Повторить", completion: loadImage),
            ]
        )
        let presenter = AlertPresenter(model: alertModel, delegate: self)
        presenter.present()
    }
    
    private lazy var returnButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "backward"), for: .normal)
        button.addTarget(self, action: #selector(didTabReturnButton), for: .touchUpInside)
        button.accessibilityIdentifier = "return button"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        configUI()
    }
    
    private func configUI() {
        view.backgroundColor = UIColor(named: "YP Black")
        
        setupConstraints()
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
        guard let image = imageView.image else { return }
        let sharingController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(sharingController, animated: true)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        scrollView.minimumZoomScale = 0.0
        scrollView.maximumZoomScale = 1.25
        
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(hScale, vScale)
        
        scrollView.setZoomScale(scale, animated: false)
        scrollView.minimumZoomScale = scale
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
        let x = max((visibleRectSize.width - newContentSize.width) / 2, 0)
        let y = max((visibleRectSize.height - newContentSize.height) / 2, 0)
        scrollView.contentInset = UIEdgeInsets(top: y, left: x, bottom: y, right: x)
    }
}
