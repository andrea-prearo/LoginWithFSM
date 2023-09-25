//
//  DefaultPrimaryButton.swift
//  LoginWithFSM
//
//  Created by Andrea Prearo on 9/24/23.
//

import SwiftUI

struct DefaultPrimaryButtonStyle: ButtonStyle {
    var disabled = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .background(disabled ? .gray : .blue)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
            .animation(.easeOut(duration: 0.25), value: configuration.isPressed)
    }
}
