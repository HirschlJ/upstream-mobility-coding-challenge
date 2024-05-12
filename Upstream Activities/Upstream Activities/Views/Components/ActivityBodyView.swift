//
//  ActivityBodyView.swift
//  Upstream Activities
//
//  Created by Jakob Hirschl on 12.05.24.
//

import SwiftUI

struct ActivityBodyView: View {
    let activity: Activity
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("txt_activity_headline")
                .font(.headline)

            Text(activity.activity)
                .font(.title)

            Text("txt_activity_type \(activity.type.rawValue)")

            Text("txt_activity_participants \(activity.participants)")

            RadingSliderView(
                label: "txt_activity_accessibility \(activity.accessibility)",
                rating: activity.accessibility
            )

            RadingSliderView(
                label: "txt_activity_price \(activity.price)",
                rating: activity.price
            )
        }
    }
}

#Preview {
    ActivityBodyView(
        activity: Activity(
            activity: "Make a pizza",
            type: .cooking,
            participants: 2,
            price: 0.2,
            accessibility: 0.45
        )
    ).padding()
}
