//
//  LoginFSMTests.swift
//  LoginWithFSMTests
//
//  Created by Andrea Prearo on 10/8/23.
//

import Foundation
@testable import LoginWithFSM
import XCTest

class LoginFSMTests: XCTestCase {
    private let sut = LoginFSM()

    func testSuccessfulLoginTransitions() {
        let authenticatedExpectation = expectation(description: "Successfully authenticated")
        authenticatedExpectation.isInverted = true

        XCTAssertEqual(sut.state, .idle)
        XCTAssertTrue(sut.processEvent(.enteringCredential(.username("some username"))))
        XCTAssertEqual(sut.state, .validatingCredentials)
        XCTAssertTrue(sut.processEvent(.enteringCredential(.password("some password"))))
        XCTAssertEqual(sut.state, .validCredentials)
        XCTAssertTrue(sut.processEvent(.authenticate))
        XCTAssertEqual(sut.state, .authenticating)

        wait(for: [authenticatedExpectation], timeout: 5.0)
        authenticatedExpectation.fulfill()
        XCTAssertEqual(sut.state, .authenticated)
    }

    func testFailedLoginTransitions() {
        let authenticatedExpectation = expectation(description: "Successfully authenticated")
        authenticatedExpectation.isInverted = true

        XCTAssertEqual(sut.state, .idle)
        XCTAssertTrue(sut.processEvent(.enteringCredential(.username("some username"))))
        XCTAssertEqual(sut.state, .validatingCredentials)
        XCTAssertTrue(sut.processEvent(.enteringCredential(.password("some password"))))
        XCTAssertEqual(sut.state, .validCredentials)
        XCTAssertTrue(sut.processEvent(.authenticate))
        XCTAssertEqual(sut.state, .authenticating)

        wait(for: [authenticatedExpectation], timeout: 2.0)
        authenticatedExpectation.fulfill()

        sut.state = .error(.invalidCredentials)
        XCTAssertTrue(sut.processEvent(.ackError))
        XCTAssertEqual(sut.state, .validCredentials)
    }

    func testInvalidTransitions() {
        XCTAssertEqual(sut.state, .idle)
        XCTAssertFalse(sut.processEvent(.authenticate))
        XCTAssertFalse(sut.processEvent(.ackError))
        XCTAssertTrue(sut.processEvent(.enteringCredential(.username("some username"))))

        sut.state = .validatingCredentials
        XCTAssertFalse(sut.processEvent(.authenticate))
        XCTAssertFalse(sut.processEvent(.ackError))
        XCTAssertTrue(sut.processEvent(.enteringCredential(.username("some username"))))

        sut.state = .validCredentials
        XCTAssertTrue(sut.processEvent(.authenticate))
        XCTAssertFalse(sut.processEvent(.ackError))
        XCTAssertFalse(sut.processEvent(.enteringCredential(.username("some username"))))

        sut.state = .authenticated
        XCTAssertFalse(sut.processEvent(.authenticate))
        XCTAssertFalse(sut.processEvent(.ackError))
        XCTAssertFalse(sut.processEvent(.enteringCredential(.username("some username"))))

        sut.state = .error(.invalidCredentials)
        XCTAssertFalse(sut.processEvent(.authenticate))
        XCTAssertFalse(sut.processEvent(.enteringCredential(.username("some username"))))
        XCTAssertTrue(sut.processEvent(.ackError))
    }
}
