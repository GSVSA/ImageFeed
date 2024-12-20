import XCTest

final class Image_FeedUITests: XCTestCase {
    private var app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launchArguments = ["testMode"]
        app.launch()
    }

    func testAuth() throws {
        let loginButton = app.buttons[Identifiers.authButtonLogin]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 2))
        loginButton.tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))

        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        XCTAssertTrue(loginTextField.wait(for: \.hasFocus, toEqual: true, timeout: 2))
        loginTextField.typeText("shvets.anna.andreevna@gmail.com") // Ввести свой логин
        loginTextField.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.exists)
        
        passwordTextField.tap()
        XCTAssertTrue(passwordTextField.wait(for: \.hasFocus, toEqual: true, timeout: 2))
        passwordTextField.typeText("t4$agN+VeCp.8&n") // Ввести свой пароль
        webView.swipeUp()

        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        let likeButton = cellToLike.buttons[Identifiers.imagesCellFavoriteButton]
        let initialIsLiked = likeButton.label == Identifiers.imagesCellFavoriteActive
        let oppositeLabel = initialIsLiked
            ? Identifiers.imagesCellFavoriteNoActive
            : Identifiers.imagesCellFavoriteActive

        likeButton.tap()
        XCTAssertTrue(likeButton.wait(for: \.label, toEqual: oppositeLabel, timeout: 2))
        
        cellToLike.tap()
        XCTAssertTrue(cell.waitForNonExistence(timeout: 3))

        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 10))

        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons[Identifiers.singleImageButtonReturn]
        navBackButtonWhiteButton.tap()
        XCTAssertTrue(cell.exists)
    }
    
    func testProfile() throws {
        let tabBarItem = app.tabBars.buttons.element(boundBy: 1)
        XCTAssertTrue(tabBarItem.waitForExistence(timeout: 3))
        tabBarItem.tap()
        XCTAssertTrue(app.wait(for: \.staticTexts["Anna Shvets"].exists, toEqual: true, timeout: 5)) // Ввести свое имя
        XCTAssertTrue(app.staticTexts["@gsvsa"].exists) // Ввести свой username
        
        app.buttons[Identifiers.profileButtonLogout].tap()
        app.alerts[Identifiers.profileAlertConfirmLogout].buttons.firstMatch.tap()

        let loginButton = app.buttons[Identifiers.authButtonLogin]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 2))
    }
}
