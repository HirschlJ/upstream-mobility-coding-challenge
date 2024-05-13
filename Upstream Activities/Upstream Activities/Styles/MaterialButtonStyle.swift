//
//  MaterialButtonStyle.swift
//  Upstream Activities
//
//  Created by Jakob Hirschl on 11.05.24.
//

import SwiftUI

struct MaterialButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool

    let buttonColor: Color = Color.accentColor
    let textColor: Color = Color("OnAccentColor")
    let cornerRadius: CGFloat = 25

    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .textCase(.uppercase)
            .multilineTextAlignment(.center)
            .frame(minWidth: 44, minHeight: 44)
            .padding(.horizontal, 16)
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(buttonColor)

                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.gray)
                        .opacity(configuration.isPressed ? 0.6 : 0.0)
                }
            }
            .animation(.easeInOut, value: configuration.isPressed)
            .opacity(isEnabled ? 1.0 : 0.5)
    }
}
