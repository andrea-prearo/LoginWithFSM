//
//  LoginViewModel.swift
//  LoginWithFSM
//
//  Created by Andrea Prearo on 9/24/23.
//

import Combine
import Foundation

class LoginViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var hasValidCredentials = false
    @Published var isLoading = false
    @Published var isAuthenticated = false
    @Published var error: LoginError?

    private var fsm: LoginFSM
    private var cancellables: Set<AnyCancellable> = []

    init(fsm: LoginFSM) {
        self.fsm = fsm
        setupSubscriptions()
    }

    func authenticate() {
        fsm.processEvent(.authenticate)
    }

    private func setupSubscriptions() {
        $username.sink { [weak self] username in
            guard let self else { return }
            self.fsm.processEvent(.validateCredential(.username(username)))
        }
        .store(in: &cancellables)

        $password.sink { [weak self] password in
            guard let self else { return }
            self.fsm.processEvent(.validateCredential(.password(password)))
        }
        .store(in: &cancellables)

        fsm.$state.sink { [weak self] state in
            guard let self else { return }
            self.hasValidCredentials = (state == .validCredentials)
            self.isLoading = (state == .authenticating)
            self.isAuthenticated = (state == .authenticated)
            if case let .error(error) = state {
                self.error = error
            } else {
                self.error = nil
            }
        }
        .store(in: &cancellables)
    }
}
