import UIKit
@preconcurrency import WebKit

final class WebViewViewController: UIViewController {
    weak var delegate: WebViewViewControllerDelegate?
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    private lazy var webView = WKWebView()
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = UIColor(named: "YP Black")
        progressView.trackTintColor = .white
        
        return progressView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        
        webView.navigationDelegate = self
        loadAuthView()
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
            options: []
        ) { [weak self] _, _ in
            guard let self = self else { return }
            self.updateProgress()
        }
    }
    
    private func setupConstraints() {
        [
            webView,
            progressView,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: Constants.authBaseURL) else {
            print("ERROR: URLComponents")
            return
        }
        
        urlComponents.path = Constants.authPath

        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]

        guard let url = urlComponents.url else {
            print("ERROR: URL is not exist")
            return
        }

        let request = URLRequest(url: url)
        webView.load(request)
    }

    private func updateProgress() {
        progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        let isMax = fabs(webView.estimatedProgress - 1.0) <= 0.0001
        if isMax {
            progressView.isHidden = true
            progressView.progress = 0
        }
    }
}

// MARK: - extensions

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}


