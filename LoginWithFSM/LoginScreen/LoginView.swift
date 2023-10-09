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
    @State private var shouldShowError: Bool = false
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }

    private func isSignInButtonDisabled() -> Bool {
        guard !viewModel.isLoading else { return true }
        return !viewModel.hasValidCredentials
    }

    var body: some View {
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
        .alert(isPresented: $shouldShowError) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.error?.localizedDescription ?? "Unknown error"),
                dismissButton: .default(Text("OK")) {
                    viewModel.ackError()
                }
            )
        }
        .onChange(of: viewModel.isAuthenticated) { isAuthenticated in
            isUserLoggedIn.wrappedValue = isAuthenticated
        }
        .onChange(of: viewModel.error) { error in
            // Make sure the full screen spinner is
            // dismissed before showing the alert.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                shouldShowError = (error != nil) && !viewModel.isLoading
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel(fsm: LoginFSM()))
    }
}
