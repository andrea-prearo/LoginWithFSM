//
//  HomeView.swift
//  LoginWithFSM
//
//  Created by Andrea Prearo on 9/26/23.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.isUserLoggedIn) private var isUserLoggedIn

    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
            }
            .padding()
            .toolbar {
                ToolbarItemGroup(placement: .navigation) {
                    Button("Log Out") {
                        isUserLoggedIn.wrappedValue = false
                    }
                }
            }
        }
    }
}
