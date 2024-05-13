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

    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    var body: some View {
        ZStack {
            VStack {
                if let activity = viewModel.activity {
                    if verticalSizeClass == .compact {
                        ScrollView {
                            ActivityBodyView(activity: activity)
                        }
                    } else {
                        ActivityBodyView(activity: activity)
                    }
                }

                Spacer()

                if horizontalSizeClass == .regular || verticalSizeClass == .compact && horizontalSizeClass == .compact {
                    HStack(spacing: 32) {
                        ActivityPickerButtonView(
                            activityType: $activityType,
                            viewModel: viewModel
                        )
                    }
                } else {
                    ActivityPickerButtonView(
                        activityType: $activityType,
                        viewModel: viewModel
                    )
                }
            }

            if viewModel.activityViewState == .loading {
                ActivityLoadingView()
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
