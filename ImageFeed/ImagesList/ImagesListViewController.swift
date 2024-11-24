import UIKit

final class ImagesListViewController: UIViewController {
    private var photos: [Photo] = []
    private let imagesListService = ImagesListService.shared

    private lazy var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        
        view.backgroundColor = UIColor(named: "YP Black")
        tableView.backgroundColor = UIColor(named: "YP Black")
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        setupConstraints()
        
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: ImagesListService.self,
            queue: .main
        ) { _ in
            print("notification")
            self.updateTableViewAnimated()
        }
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: - extensions

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)

        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }

        configCell(for: imageListCell, with: indexPath)

        return imageListCell
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let imageInfo = photos[indexPath.row]
        guard
            let imageURL = URL(string: imageInfo.thumbImageURL)
        else { return }
        
        let imageView = UIImageView()
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "stubImage")) { [weak self] _ in
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        cell.setCellImage(imageView)
        cell.setFavoritesButtonState(isActive: imageInfo.isLiked)
        guard let createdDate = imageInfo.createdAt else { return }
        cell.setDateLabel(date: createdDate)
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = SingleImageViewController()
        viewController.modalPresentationStyle = .fullScreen
        // TODO: Изменить способ передачи изображения
//        let imageURL = imagesListService.photos[indexPath.row].fullImageURL
//        viewController.image = image
        present(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageSize = photos[indexPath.row].size
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        if imageSize.width == 0 {
            return 0
        }
        let scale = imageViewWidth / imageSize.width
        let cellHeight = imageSize.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
}
