//
//  APIError.swift
//  Upstream Activities
//
//  Created by Jakob Hirschl on 10.05.24.
//

import Foundation

/// Errors that can occur on communicating with an API.
enum APIError: Error {
    case transportError(Error)
    case serverError(Int, String)
    case parsingError(Error)
}
