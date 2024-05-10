//
//  GetActivityRessource.swift
//  Upstream Activities
//
//  Created by Jakob Hirschl on 10.05.24.
//

import Foundation

class GetActivityRessource: APIRessource {
    typealias ResponseModelType = Activity

    let resourcePath: String = "activity"
    let httpMethod: HTTPMethod = .get
    let queryItems: [URLQueryItem]?

    init(activityType: String?) {
        if let activityType = activityType {
            queryItems = [URLQueryItem(name: "type", value: activityType)]
        } else {
            queryItems = nil
        }
    }
}
