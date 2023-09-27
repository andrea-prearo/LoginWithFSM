//
//  ContentView.swift
//  LoginWithFSM
//
//  Created by Andrea Prearo on 9/24/23.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.isUserLoggedIn) private var isUserLoggedIn

    @ObservedObject private var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }

    private func isSignInButtonDisabled() -> Bool {
        guard !viewModel.isLoading else { return true }
        return !viewModel.hasValidCredentials
    }

    var body: some View {
        let viewModelErroBinding = Binding(
            get: { self.viewModel.error != nil },
            set: {_ in }
        )

        NavigationView {
            VStack {
                GroupBox {
                    TextField("Username", text: $viewModel.username)
                        .textFieldStyle(.roundedBorder)
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(.roundedBorder)
                    Button("Sign In") {
                        viewModel.authenticate()
                    }
                    .buttonStyle(DefaultPrimaryButtonStyle(disabled: isSignInButtonDisabled()))
                }
                .padding(.horizontal)
                .navigationDestination(for: Bool.self) { _ in
                    HomeView()
                }
                .fullScreenCover(isPresented: $viewModel.isLoading) {
                    ProgressView()
                        .background(BackgroundBlurView())
                }
            }
        }
        .alert(isPresented: viewModelErroBinding) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.error?.localizedDescription ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        }
        .onChange(of: viewModel.isAuthenticated) { isAuthenticated in
            isUserLoggedIn.wrappedValue = isAuthenticated
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel(fsm: LoginFSM()))
    }
}
