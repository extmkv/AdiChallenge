//
//  HTTPRequest.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 03/02/2021.
//

import Foundation

typealias HTTPRequestResult = HTTPResult<HTTPResponse>

final class HTTPRequest {

    final class Path {

        private var components: URLComponents
        private var queryItems: [URLQueryItem]?

        init(_ path: String) {
            self.components = URLComponents(string: path).require()
        }

        func setQueryItem(_ name: String, value: String) {
            if self.queryItems == nil {
                self.queryItems = []
            }
            self.queryItems?.append(URLQueryItem(name: name, value: value))
        }

        func url(relativeTo base: URL) -> URL {
            self.components.queryItems = self.queryItems
            self.components.percentEncodedQuery = self.components.percentEncodedQuery
            return self.components.url(relativeTo: base).require()
        }
    }

    enum Method: String {
        case GET
        case POST
        case PUT
        case DELETE
    }

    let path: Path
    let method: Method
    let headers: HTTPHeaders = {
        let headers = HTTPHeaders()
        headers.accept = .json
        return headers
    }()
    var body: HTTPRequestBody?

    init(path: Path, method: Method) {
        self.path = path
        self.method = method
    }
}
