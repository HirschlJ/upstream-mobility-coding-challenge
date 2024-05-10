//
//  Activity.swift
//  Upstream Activities
//
//  Created by Jakob Hirschl on 10.05.24.
//

import Foundation

/// Model describing an activity returned by https://www.boredapi.com
/// Description of the parameters was taken from https://www.boredapi.com/documentation#endpoints-accessibility
struct Activity: Decodable {
    /// Description of the queried activity
    let activity: String
    /// Type of the activity ["education", "recreational", "social", "diy", "charity", "cooking", "relaxation", "music", "busywork"]
    let type: String
    /// The number of people that this activity could involve [0, n]
    let participants: Int
    /// A factor describing the cost of the event with zero being free [0, 1]
    let price: Double
    /// A factor describing how possible an event is to do with zero being the most accessible [0.0, 1.0]
    let accessibility: Double
}
