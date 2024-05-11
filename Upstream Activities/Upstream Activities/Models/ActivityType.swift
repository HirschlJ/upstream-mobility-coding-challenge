//
//  ActivityType.swift
//  Upstream Activities
//
//  Created by Jakob Hirschl on 11.05.24.
//

import SwiftUI

enum ActivityType: String, Decodable, CaseIterable {
    case education
    case recreational
    case social
    case diy
    case charity
    case cooking
    case relaxation
    case music
    case busywork

    var localizedStringKey: LocalizedStringKey {
        return LocalizedStringKey("txt_activity_type_" + self.rawValue)
    }
}
