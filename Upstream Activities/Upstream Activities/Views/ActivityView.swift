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

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    let _ = Container.shared.activityViewModel.register { ActivityViewModel() }
    return ActivityView()
}
