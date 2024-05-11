//
//  ActivityLoadingView.swift
//  Upstream Activities
//
//  Created by Jakob Hirschl on 11.05.24.
//

import SwiftUI

struct ActivityLoadingView: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            Text("txt_activity_loading")
            ProgressView()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 5.0)
                .fill(colorScheme == .dark ? Color.black : Color.white)
                .shadow(
                    color: colorScheme == .dark ?
                        Color.white.opacity(0.33) : Color.gray.opacity(0.33),
                    radius: 2
                )
        )
    }
}

#Preview {
    ActivityLoadingView()
}
