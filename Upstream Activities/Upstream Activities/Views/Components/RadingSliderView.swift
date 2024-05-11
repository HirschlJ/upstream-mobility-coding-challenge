//
//  RadingSliderView.swift
//  Upstream Activities
//
//  Created by Jakob Hirschl on 11.05.24.
//

import SwiftUI

struct RadingSliderView: View {
    let label: LocalizedStringKey
    let rating: Double

    private let gradient = LinearGradient(
        colors: [Color.red, Color.yellow, Color.green],
        startPoint: .leading,
        endPoint: .trailing
    )

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(gradient)

                    Rectangle()
                        .fill(Color.black)
                        .frame(width: 2)
                        .offset(x: rating * geometry.size.width - 1)
                }
            }.frame(height: 20)
        }

    }
}

#Preview {
    RadingSliderView(
        label: "txt_activity_price \(0.5)", rating: 0.5
    )
}
