//
//  LoginWithFSMApp.swift
//  LoginWithFSM
//
//  Created by Andrea Prearo on 9/24/23.
//

import SwiftUI

@main
struct LoginWithFSMApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView(viewModel: LoginViewModel(fsm: LoginFSM()))
        }
    }
}
