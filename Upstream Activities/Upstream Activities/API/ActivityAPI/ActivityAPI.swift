//
//  ActivityAPI.swift
//  Upstream Activities
//
//  Created by Jakob Hirschl on 10.05.24.
//

import Foundation

/// API for retrieving an activity, optionally with a specific activity type, from https://www.boredapi.com.
protocol ActivityAPI {
    /// Returns a random activity from https://www.boredapi.com/activity
    /// - Parameter activityType: If set, only activities of the given type will be returned.
    func getActivity(activityType: ActivityType?) async throws -> Activity
}

class ActivityAPIImpl: ActivityAPI {
    func getActivity(activityType: ActivityType?) async throws -> Activity {
        return try await APIRequest(ressource: GetActivityRessource(activityType: activityType?.rawValue)).execute()
    }
}
