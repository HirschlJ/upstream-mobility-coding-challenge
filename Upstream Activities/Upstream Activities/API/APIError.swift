//
//  APIError.swift
//  Upstream Activities
//
//  Created by Jakob Hirschl on 10.05.24.
//

import SwiftUI

/// Errors that can occur on communicating with an API.
enum APIError: Error {
    case transportError(Error)
    case serverError(Int, String)
    case parsingError(Error)
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .transportError:
            NSLocalizedString("alert_activity_message_transport", comment: "")
        case .serverError:
            NSLocalizedString("alert_activity_message_server", comment: "")
        case .parsingError:
            NSLocalizedString("alert_activity_message_parsing", comment: "")
        }
    }
}
