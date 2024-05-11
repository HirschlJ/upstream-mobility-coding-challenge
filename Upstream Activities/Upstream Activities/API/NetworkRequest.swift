//
//  NetworkRequest.swift
//  Upstream Activities
//
//  Created by Jakob Hirschl on 10.05.24.
//

import Foundation

/// Protocol describing a simple network request
protocol NetworkRequest: AnyObject {
    associatedtype ResponseModelType: Decodable

    var urlSession: URLSessionAPI { get }

    /// Function called on decoding data returned by the request
    func decode(_ data: Data) throws -> ResponseModelType
    /// Executes this NetworkRequest
    func execute() async throws -> ResponseModelType
}

extension NetworkRequest {
    /// Executes a specific request and returns the parsed response.
    /// - Throws: ``APIError/transportError(_:)`` if the request times out or fails for other reasons without 
    /// getting a repsonse from the server.
    /// - Throws: ``APIError/parsingError(_:)`` if parsing the `ResponseModelType` fails.
    /// - Throws: ``APIError/serverError(_:_:)`` if the status code of the response does not signal success.
    func executeRequest(_ request: URLRequest) async throws -> ResponseModelType {
        let data: Data
        let urlRespose: URLResponse
        do {
            (data, urlRespose) = try await urlSession.data(for: request)
        } catch {
            throw APIError.transportError(error)
        }

        // swiftlint:disable force_cast
        return try handleResponse(data, urlRespose as! HTTPURLResponse)
        // swiftlint:enable force_cast
    }

    /// Handles a response by checking its status code and decoding the response.
    /// - Throws: ``APIError/parsingError(_:)`` if parsing the `ResponseModelType` fails.
    /// - Throws: ``APIError/serverError(_:_:)`` if the status code of the response does not signal success.
    func handleResponse(_ data: Data, _ urlRespose: HTTPURLResponse) throws -> ResponseModelType {
        guard(200...299).contains(urlRespose.statusCode) else {
            throw APIError.serverError(urlRespose.statusCode, String(bytes: data, encoding: .utf8) ?? "")
        }

        do {
            return try decode(data)
        } catch {
            throw APIError.parsingError(error)
        }
    }
}
