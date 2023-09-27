//
//  LoginFSM.swift
//  LoginWithFSM
//
//  Created by Andrea Prearo on 9/24/23.
//

import Foundation

enum LoginError: Error {
    case invalidCredentials
    case networkError(Error)
}

enum LoginCredential {
    case username(String)
    case password(String)
}

enum LoginEvent {
    case validateCredential(LoginCredential)
    case authenticate
}

enum LoginState: Equatable {
    case idle
    case validatingCredentials
    case validCredentials
    case authenticating
    case authenticated
    case error(LoginError)

    func canProcessEvent(event: LoginEvent) -> Bool {
        switch event {
        case .validateCredential(_):
            return self == .idle ||
            self == .validatingCredentials ||
            self == .validCredentials
        case .authenticate:
            return self == .validCredentials
        }
    }

    static func == (lhs: LoginState, rhs: LoginState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.validatingCredentials, .validatingCredentials):
            return true
        case (.validCredentials, .validCredentials):
            return true
        case (.authenticating, .authenticating):
            return true
        case (.authenticated, .authenticated):
            return true
        case (.error(_), .error(_)):
            return true
        default:
            return false
        }
    }
}

class LoginFSM: ObservableObject {
    @Published var state: LoginState = .idle

    private var hasValidUsername = false
    private var hasValidPassword = false
    private var hasValidCredentials: Bool {
        return hasValidUsername && hasValidPassword
    }

    /// Process an event.
    /// - Parameter event: event to process.
    /// - Returns: Wheter the event processing was successful or no.
    ///            Invalid transitions will return `false`.
    @discardableResult
    func processEvent(_ event: LoginEvent) -> Bool {
        guard state.canProcessEvent(event: event) else {
            print("Can't process event \(event) for state \(state)")
            return false
        }

        switch event {
        case .validateCredential(let credential):
            switch credential {
            case .username(let value):
                hasValidUsername = validateUsername(value)
                if hasValidCredentials {
                    state = .validCredentials
                } else {
                    state = .validatingCredentials
                }
            case .password(let value):
                hasValidPassword = validatePassword(value)
                if hasValidCredentials {
                    state = .validCredentials
                } else {
                    state = .validatingCredentials
                }
            }
        case .authenticate:
            state = .authenticating
            // Simulate network call
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                guard let self else { return }
                self.state = .authenticated
            }
        }
        return false
    }

    private func validateUsername(_ value: String) -> Bool {
        return value.count >= 8
    }

    private func validatePassword(_ value: String) -> Bool {
        return value.count >= 8
    }
}
