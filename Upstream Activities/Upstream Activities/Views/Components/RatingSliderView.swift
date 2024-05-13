//
//  RatingSliderView.swift
//  Upstream Activities
//
//  Created by Jakob Hirschl on 11.05.24.
//

import SwiftUI

/// A view that shows a rating between 0 and 1 in a slider like visualization.
/// The given label is shown above the visualization.
struct RatingSliderView: View {
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
    RatingSliderView(
        label: "txt_activity_price \(0.5)", rating: 0.5
    )
}
