//
//  AppContainer.swift
//  Upstream Activities
//
//  Created by Jakob Hirschl on 10.05.24.
//

import Factory
import Foundation

extension Container {
    var urlSession: Factory<URLSessionAPI> {
        self { URLSession.shared }
    }

    var activityApi: Factory<ActivityAPI> {
        self { ActivityAPIImpl() }
    }

    var activityViewModel: Factory<ActivityViewModel> {
        self { ActivityViewModelImpl() }
    }
}
