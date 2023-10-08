//
//  LoginViewModel.swift
//  LoginWithFSM
//
//  Created by Andrea Prearo on 9/24/23.
//

import Combine
import SwiftUI

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
        $username.sink { [weak self] value in
            guard let self else { return }
            self.fsm.processEvent(.enteringCredential(.username(value)))
        }
        .store(in: &cancellables)

        $password.sink { [weak self] value in
            guard let self else { return }
            self.fsm.processEvent(.enteringCredential(.password(value)))
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
