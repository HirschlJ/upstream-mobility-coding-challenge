//
//  ActivityPickerButtonView.swift
//  Upstream Activities
//
//  Created by Jakob Hirschl on 12.05.24.
//

import SwiftUI

/// View displaying the activity type picker and button to fetch a new activity.
struct ActivityPickerButtonView: View {
    @Binding var activityType: ActivityType?
    var viewModel: ActivityViewModel

    var body: some View {
        ActivityTypePicker(activityType: $activityType)
            .disabled(viewModel.activityViewState == .loading)

        Button {
            viewModel.fetchNewActivity(activityType: activityType)
        } label: {
            Text("btn_activity_fetch")
        }
        .buttonStyle(MaterialButtonStyle())
        .disabled(viewModel.activityViewState == .loading)
    }
}

#Preview {
    ActivityPickerButtonView(
        activityType: .constant(.busywork),
        viewModel: ActivityViewModel()
    )
}
