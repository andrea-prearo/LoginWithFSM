//
//  isUserLoggedIn.swift
//  LoginWithFSM
//
//  Created by Andrea Prearo on 9/26/23.
//

import SwiftUI

private struct UserLoggedIneKey: EnvironmentKey {
    static var defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var isUserLoggedIn: Binding<Bool> {
        get { self[UserLoggedIneKey.self] }
        set { self[UserLoggedIneKey.self] = newValue }
    }
}

extension View {
    func isUserLoggedIn(_ value: Binding<Bool>) -> some View {
        environment(\.isUserLoggedIn, value)
    }
}
