//
//  ActivityViewModel.swift
//  Upstream Activities
//
//  Created by Jakob Hirschl on 10.05.24.
//

import Foundation
import Observation
import Factory

@Observable
class ActivityViewModel {
    /// The current state of the view.
    /// See ``ActivityViewState``.
    /// If the state is set to ``ActivityViewState/error(_:)``, ``showAlert`` will be set to true automatically.
    fileprivate(set) var activityViewState: ActivityViewState = .loading {
        didSet {
            showAlert = activityViewState.isError
        }
    }

    var showAlert: Bool = false

    fileprivate(set) var activity: Activity?

    func fetchNewActivity(activityType: String?) { }
}

class ActivityViewModelImpl: ActivityViewModel {
    @Injected(\.activityApi) var activityAPI: ActivityAPI

    override func fetchNewActivity(activityType: String?) {
        activityViewState = .loading
        Task(priority: .userInitiated) {
            do {
                let fetchedActivity = try await activityAPI.getActivity(activityType: activityType)
                DispatchQueue.main.sync {
                    activityViewState = .success
                    activity = fetchedActivity
                }
            } catch {
                DispatchQueue.main.sync {
                    activityViewState = .error(error.toEquatableError())
                }
            }
        }
    }
}

/// Enum describing the state of an activity view.
/// ``ActivityViewState/loading`` -> Currently busy fetching a new activity.
/// ``ActivityViewState/error(_:)`` -> Fetching an activity failed.
/// ``ActivityViewState/success`` -> Successfully fetched a new activity.
enum ActivityViewState: Equatable {
    case loading
    case error(EquatableError)
    case success

    var isError: Bool {
        switch self {
        case .error:
            true
        default:
            false
        }
    }
}
