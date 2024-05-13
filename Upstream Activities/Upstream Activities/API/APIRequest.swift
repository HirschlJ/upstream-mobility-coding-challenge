//
//  APIRequest.swift
//  Upstream Activities
//
//  Created by Jakob Hirschl on 10.05.24.
//

import Factory
import Foundation

class APIRequest<Ressource: APIRessource> {
    @Injected(\.urlSession) var urlSession: URLSessionAPI

    let ressource: Ressource

    init(ressource: Ressource) {
        self.ressource = ressource
    }
}

extension APIRequest: NetworkRequest {
    func decode(_ data: Data) throws -> Ressource.ResponseModelType {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(Ressource.ResponseModelType.self, from: data)
    }

    func execute() async throws -> Ressource.ResponseModelType {
        return try await executeRequest(ressource.request)
    }
}
