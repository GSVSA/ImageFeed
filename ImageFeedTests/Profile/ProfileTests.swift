import Foundation
import XCTest
@testable import ImageFeed

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
