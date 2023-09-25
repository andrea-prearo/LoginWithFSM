//
//  ContentView.swift
//  LoginWithFSM
//
//  Created by Andrea Prearo on 9/24/23.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject private var viewModel: LoginViewModel

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            GroupBox {
                TextField("Username", text: $viewModel.username)
                    .textFieldStyle(.roundedBorder)
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(.roundedBorder)
                Button("Sign In") {
                    print("OK")
                }
                .buttonStyle(DefaultPrimaryButtonStyle(disabled: !viewModel.hasValidCredentials))
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel(fsm: LoginFSM()))
    }
}
