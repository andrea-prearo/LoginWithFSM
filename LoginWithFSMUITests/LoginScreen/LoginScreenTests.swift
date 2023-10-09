//
//  LoginScreenTests.swift
//  LoginWithFSMUITests
//
//  Created by Andrea Prearo on 10/8/23.
//

import Foundation
import XCTest

class LoginScreenTests: XCTestCase {
    static let eventTimeout = TimeInterval(2)

    func testSuccessfulLogin() throws {
        let app = XCUIApplication()
        app.launch()

        let usernameField = app.textFields.element(boundBy: 0)
        usernameField.tap()
        usernameField.typeText("iostester1")
        let passwordField = app.secureTextFields.element(boundBy: 0)
        passwordField.tap()
        passwordField.typeText("thisisatest")

        let signInButton = app.buttons["Sign In"]
        signInButton.tap()

        let logOutButton = app.buttons["Log Out"]
        XCTAssertTrue(logOutButton.waitForExistence(timeout: LoginScreenTests.eventTimeout))
    }
}
