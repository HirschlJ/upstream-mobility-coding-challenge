//
//  AppContainer.swift
//  Upstream Activities
//
//  Created by Jakob Hirschl on 10.05.24.
//

import Factory

extension Container {
    var activityApi: Factory<ActivityAPI> {
        self { ActivityAPIImpl() }
    }

    var activityViewModel: Factory<ActivityViewModel> {
        self { ActivityViewModelImpl() }
    }
}
