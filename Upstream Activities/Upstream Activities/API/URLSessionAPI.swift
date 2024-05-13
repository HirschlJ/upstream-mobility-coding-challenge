//
//  URLSessionAPI.swift
//  Upstream Activities
//
//  Created by Jakob Hirschl on 11.05.24.
//

import Foundation

protocol URLSessionAPI {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionAPI { }
