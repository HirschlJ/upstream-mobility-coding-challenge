//
//  APIRessource.swift
//  Upstream Activities
//
//  Created by Jakob Hirschl on 10.05.24.
//

import Foundation

protocol APIRessource {
    associatedtype ResponseModelType: Decodable

    /// The relative apth of the api resource without leading '/'.
    var resourcePath: String { get }

    /// Query Items to be added to the url.
    var queryItems: [URLQueryItem]? { get }

    /// The HTTP method of the quest (see ``HTTPMethod``).
    var httpMethod: HTTPMethod { get }

    /// The encodable object that should be added as json body to the request.
    var requestBody: Encodable? { get }

    /// String pairs where the key corresponds to the http header field and the value to the value it should be set to.
    var headers: [String: String] { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case deelte = "DELTE"
}

extension APIRessource {
    var queryItems: [URLQueryItem]? { nil }
    var requestBody: Encodable? { nil }
    var headers: [String: String] { [:] }

    private var url: URL {
        let urlComponents = URLComponents(string: APIConstants.serverURL)
        guard var urlComponents = urlComponents else {
            fatalError("Could not create URLComponents from string \(APIConstants.serverURL)")
        }
        urlComponents.path.append(resourcePath)
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            fatalError("Could not create url from URLComponents with resourcePath \(resourcePath) and queryItems \(String(describing: queryItems))")
        }
        return url
    }

    /// The URLRequest for this APIRessource
    var request: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        if let requestBody = requestBody {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            request.httpBody = try? encoder.encode(requestBody)
        }
        headers.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        return request
    }
}
