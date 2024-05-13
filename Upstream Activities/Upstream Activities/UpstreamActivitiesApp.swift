//
//  UpstreamActivitiesApp.swift
//  Upstream Activities
//
//  Created by Jakob Hirschl on 10.05.24.
//

import SwiftUI

@main
struct UpstreamActivitiesApp: App {
    var body: some Scene {
        WindowGroup {
            if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
                Text("placeholder_unit_testing")
            } else {
                ActivityView()
            }
        }
    }
}
