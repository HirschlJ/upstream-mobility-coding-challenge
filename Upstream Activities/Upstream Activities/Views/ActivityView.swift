//
//  ActivityView.swift
//  Upstream Activities
//
//  Created by Jakob Hirschl on 10.05.24.
//

import SwiftUI
import Factory

struct ActivityView: View {
    @State var viewModel: ActivityViewModel = Container.shared.activityViewModel()
    @State var activityType: ActivityType?

    var body: some View {
        ZStack {
            if viewModel.activityViewState == .loading {
                ActivityLoadingView()
            }

            VStack(alignment: .leading, spacing: 16) {
                if let activity = viewModel.activity {
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

                Spacer()

                VStack {
                    ActivityTypePicker(activityType: $activityType)
                        .disabled(viewModel.activityViewState == .loading)

                    Button {
                        viewModel.fetchNewActivity(activityType: activityType)
                    } label: {
                        Text("btn_activity_fetch")
                    }
                    .buttonStyle(MaterialButtonStyle())
                    .disabled(viewModel.activityViewState == .loading)
                }.frame(maxWidth: .infinity)
            }
        }
        .padding()
        .alert(
            "alert_activity_title",
            isPresented: $viewModel.showAlert,
            presenting: viewModel.activityViewState
        ) { _ in } message: { state in
            switch state {
            case .error(let error):
                Text(error.localizedDescription)
            default:
                Text("alert_activity_message_other")
            }
        }
        .onAppear {
            viewModel.fetchNewActivity(activityType: activityType)
        }
    }
}

#Preview("Loading") {
    _ = Container.shared.activityViewModel.register { ActivityViewModel() }
    return ActivityView()
}

#Preview("Error") {
    _ = Container.shared.activityViewModel.register {
        ActivityViewModel(activityViewState: .error(APIError.serverError(404, "Not found").toEquatableError()))
    }
    return ActivityView()
}

#Preview("Success") {
    _ = Container.shared.activityViewModel.register {
        ActivityViewModel(
            activityViewState: .success,
            activity: Activity(
                activity: "Make a pizza",
                type: .cooking,
                participants: 2,
                price: 0.2,
                accessibility: 0.45
            )
        )
    }
    return ActivityView()
}
