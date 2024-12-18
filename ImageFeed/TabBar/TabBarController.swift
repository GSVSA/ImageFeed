import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabItems()
        configUI()
    }
    
    private func setupTabItems() {
        let imagesListViewController = ImagesListViewController()
        let imagesListPresenter = ImagesListPresenter(imagesListService: ImagesListService.shared)
        imagesListViewController.presenter = imagesListPresenter
        imagesListPresenter.view = imagesListViewController
        imagesListViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tabEditorialActive"),
            selectedImage: nil
        )
        
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfilePresenter(
            profileService: ProfileService.shared,
            profileImageService: ProfileImageService.shared,
            profileLogoutService: ProfileLogoutService.shared
        )
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tabProfileActive"),
            selectedImage: nil
        )
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
    
    private func configUI() {
        self.tabBar.barTintColor = UIColor(named: "YP Black")
        self.tabBar.tintColor = .white
    }
}
