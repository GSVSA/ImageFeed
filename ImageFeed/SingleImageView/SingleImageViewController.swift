import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage? {
        didSet {
            guard isViewLoaded, let image else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        imageView.frame.size = image?.size ?? CGSizeZero
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        guard let image else { return }
        rescaleAndCenterImageInScrollView(image: image)
    }

    @IBAction private func didTabReturnButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction private func didTapShareButton(_ sender: UIButton) {
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
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        
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
