//
//  HTTPRequestJSONBody.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 03/02/2021.
//

import Foundation

private var _defaultEncoder: JSONEncoder = JSONEncoder()

final class HTTPRequestJSONBody<T: Encodable>: HTTPRequestBody {
    static var defaultEncoder: JSONEncoder {
        return _defaultEncoder
    }

    private let value: T
    private let encoder: JSONEncoder

    init(_ value: T, encoder: JSONEncoder? = nil) {
        self.value = value
        self.encoder = encoder ?? _defaultEncoder
    }

    func data() throws -> Data {
        return try self.encoder.encode(self.value)
    }

    func headers() -> HTTPHeaders {
        let headers = HTTPHeaders()
        headers.contentType = .json
        return headers
    }
}
