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

    private var fsm: LoginFSM
    private var cancellables: Set<AnyCancellable> = []

    init(fsm: LoginFSM) {
        self.fsm = fsm
        setupSubscriptions()
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
        }
        .store(in: &cancellables)
    }
}
