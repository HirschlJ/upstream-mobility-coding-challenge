//
//  ActivityTypePicker.swift
//  Upstream Activities
//
//  Created by Jakob Hirschl on 11.05.24.
//

import SwiftUI

struct ActivityTypePicker: View {
    @Binding var activityType: ActivityType?

    var body: some View {
        HStack {
            Text("txt_activity_type")

            Picker("txt_activity_type", selection: $activityType) {
                Text("txt_activity_type_all")
                    .tag(nil as ActivityType?)
                ForEach(ActivityType.allCases, id: \.rawValue) { activityType in
                    Text(activityType.localizedStringKey)
                        .tag(activityType as ActivityType?)
                }
            }
        }
    }
}

#Preview {
    struct Preview: View {
        @State var activityType: ActivityType? = .busywork

        var body: some View {
            ActivityTypePicker(activityType: $activityType)
        }
    }
    return Preview()
}
