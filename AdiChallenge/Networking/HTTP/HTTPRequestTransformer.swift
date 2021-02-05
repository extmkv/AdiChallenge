//
//  HTTPRequestTransformer.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 03/02/2021.
//

import Foundation

protocol HTTPRequestTransformer {
    func urlRequest(from httpRequest: HTTPRequest) -> URLRequest
}

final class DefaultHTTPRequestTransformer: HTTPRequestTransformer {

    private let baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    func urlRequest(from httpRequest: HTTPRequest) -> URLRequest {
        var urlRequest = URLRequest(url: httpRequest.path.url(relativeTo: self.baseURL),
                                    cachePolicy: .reloadIgnoringCacheData,
                                    timeoutInterval: 10)
        urlRequest.httpMethod = httpRequest.method.rawValue
        let headers = httpRequest.headers
        if let body = httpRequest.body {
            urlRequest.httpBody = try? httpRequest.body?.data()
            headers.updateWithHeaders(body.headers())
        }
        urlRequest.allHTTPHeaderFields = headers.rawValue
        return urlRequest
    }
}
