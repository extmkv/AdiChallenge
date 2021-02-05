//
//  HTTPResponse.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 03/02/2021.
//

import Foundation

protocol HTTPResponse {
    var statusCode: Int { get }
    var headers: HTTPHeaders { get }
    var data: Data { get }
}

final class DefaultHTTPResponse: HTTPResponse {

    let statusCode: Int
    let headers: HTTPHeaders
    let data: Data

    init(with response: HTTPURLResponse, data: Data) {
        self.statusCode = response.statusCode
        self.headers = HTTPHeaders(response.allHeaderFields)
        self.data = data
    }

    init(statusCode: Int, headers: HTTPHeaders, data: Data) {
        self.statusCode = statusCode
        self.headers = headers
        self.data = data
    }
}
