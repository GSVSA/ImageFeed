import UIKit

struct AlertAction {
    let title: String
    let completion: (() -> Void)?
}

struct AlertModel {
    let identifier: String?
    let title: String
    let message: String?
    let buttons: [AlertAction]?
}

enum AlertConstants {
    static let title = "Что-то пошло не так("
    static let message = "Не удалось поставить лайк"
    static let mainButtonText = "Ок"
    static let identifier = "confirm alert"
}

final class AlertPresenter {
    weak var delegate: UIViewController?

    private let alert: UIAlertController
    
    init(model: AlertModel, delegate: UIViewController? = nil) {
        self.delegate = delegate
        
        alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        
        alert.view.accessibilityIdentifier = model.identifier ?? AlertConstants.identifier
        
        model.buttons?.forEach { button in
            let action = UIAlertAction(title: button.title, style: .default) { _ in
                button.completion?()
            }
            
            alert.addAction(action)
        }
    }
    
    init(message: String, delegate: UIViewController? = nil) {
        self.delegate = delegate
        
        alert = UIAlertController(
            title: AlertConstants.title,
            message: message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: AlertConstants.mainButtonText, style: .default)
        
        alert.view.accessibilityIdentifier = AlertConstants.identifier
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
