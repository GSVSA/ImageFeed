import Foundation
@testable import ImageFeed

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
