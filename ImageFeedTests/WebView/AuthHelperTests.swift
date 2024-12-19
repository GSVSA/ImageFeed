import Foundation
@testable import ImageFeed
import XCTest

final class AuthHelperTests: XCTestCase {
    func testAuthHelperAuthURL() {
        // given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        // when
        let url = authHelper.authURL

        guard let urlString = url?.absoluteString else {
            XCTFail("Auth URL is nil")
            return
        }

        // then
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() {
        // given
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native") else {
            XCTFail("URLComponents is nil")
            return
        }
        let testCodeValue = "test code"
        urlComponents.queryItems = [URLQueryItem(name: "code", value: testCodeValue)]
        guard let url = urlComponents.url else {
            XCTFail("URL is nil")
            return
        }
        
        // when
        let code = AuthHelper().getCode(from: url)
        
        // then
        XCTAssertEqual(code, testCodeValue)
    }
}
