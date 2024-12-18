import Foundation
import XCTest
@testable import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func logout() {}
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    var avatarURLSetterCalled = false
    var profileSetterCalled = false
    var navigationCalled = false
    
    func setAvatarURL(_ url: URL) {
        avatarURLSetterCalled = true
    }
    
    func setProfileData(_ profile: Profile) {
        profileSetterCalled = true
    }
    
    func navigateToRoot() {
        navigationCalled = true
    }
}

final class ProfileImageServiceSpy: ProfileImageServiceProtocol {
    let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderSpyDidChange")
    static let shared = ProfileImageServiceSpy()
    private(set) var avatarUrl: String? = "http://example.com/avatar.jpg"
    
    private init() {}
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, any Error>) -> Void) {}
    
    func reset() {}
}

final class ProfileServiceSpy: ProfileServiceProtocol {
    static let shared = ProfileServiceSpy()

    private(set) var profile: Profile? = Profile(username: "johndaw", name: "John Daw", loginName: "@johndaw", bio: nil)
    
    private init() {}
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {}
    
    func reset() {}
}

final class ProfileTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsAvatarURLSetter() {
        // given
        let viewController = ProfileViewControllerSpy()
        let profileService = ProfileService.shared
        let profileImageService = ProfileImageServiceSpy.shared
        let profileLogoutService = ProfileLogoutService.shared
        
        let presenter = ProfilePresenter(
            profileService: profileService,
            profileImageService: profileImageService,
            profileLogoutService: profileLogoutService
        )
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertTrue(viewController.avatarURLSetterCalled)
    }
    
    func testPresenterCallsProfileSetter() {
        // given
        let viewController = ProfileViewControllerSpy()
        let profileService = ProfileServiceSpy.shared
        let profileImageService = ProfileImageService.shared
        let profileLogoutService = ProfileLogoutService.shared
        
        let presenter = ProfilePresenter(
            profileService: profileService,
            profileImageService: profileImageService,
            profileLogoutService: profileLogoutService
        )
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertTrue(viewController.profileSetterCalled)
    }
    
    func testPresenterCallsNavigation() {
        // given
        let viewController = ProfileViewControllerSpy()
        let profileService = ProfileService.shared
        let profileImageService = ProfileImageService.shared
        let profileLogoutService = ProfileLogoutService.shared
        
        let presenter = ProfilePresenter(
            profileService: profileService,
            profileImageService: profileImageService,
            profileLogoutService: profileLogoutService
        )
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        presenter.logout()
        
        // then
        XCTAssertTrue(viewController.navigationCalled)
    }
}
