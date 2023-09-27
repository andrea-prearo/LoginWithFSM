//
//  LandingView.swift
//  LoginWithFSM
//
//  Created by Andrea Prearo on 9/26/23.
//

import SwiftUI

struct LandingView: View {
    @Environment(\.isUserLoggedIn) private var isUserLoggedIn

    var body: some View {
        if isUserLoggedIn.wrappedValue {
            HomeView()
        } else {
            LoginView(viewModel: LoginViewModel(fsm: LoginFSM()))
        }
    }
}
