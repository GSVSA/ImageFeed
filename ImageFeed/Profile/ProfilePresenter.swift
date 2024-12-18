import Foundation

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func logout()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    let profileService: ProfileServiceProtocol
    let profileLogoutService: ProfileLogoutService
    let profileImageService: ProfileImageServiceProtocol
    var profileImageServiceObserver: NSObjectProtocol?
    
    init(
        profileService: ProfileServiceProtocol,
        profileImageService: ProfileImageServiceProtocol,
        profileLogoutService: ProfileLogoutService
    ) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.profileLogoutService = profileLogoutService
    }
    
    func viewDidLoad() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: profileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.didUpdateAvatarUrl()
            }
        
        didUpdateAvatarUrl()
        
        guard let profileData = profileService.profile else { return }
        view?.setProfileData(profileData)
    }
    
    func logout() {
        profileLogoutService.logout()
        view?.navigateToRoot()
    }
    
    private func didUpdateAvatarUrl() {
        guard
            let profileImageURL = profileImageService.avatarUrl,
            let url = URL(string: profileImageURL)
        else { return }
        view?.setAvatarURL(url)
    }
}
