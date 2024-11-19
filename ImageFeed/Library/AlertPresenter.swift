import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
}

final class AlertPresenter {
    private let alert: UIAlertController
    private let action: UIAlertAction
    
    weak var delegate: UIViewController?
    
    init(model: AlertModel, delegate: UIViewController? = nil) {
        self.delegate = delegate
        
        alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        
        action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion?()
        }
        
        alert.addAction(action)
    }
    
    func present() {
        assert(Thread.isMainThread)
        guard let viewController = delegate else { return }
        if viewController.isViewLoaded && viewController.view.window != nil {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
