//
//  HTTPHeaders.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 03/02/2021.
//

import Foundation

final class HTTPHeaders {

    struct Key: Hashable {

        static let ContentType = "Content-Type"
        static let Accept = "Accept"
        static let Authorization = "Authorization"

        let value: String

        init(_ value: String) {
            self.value = value
        }
    }

    enum ContentType: String {
        case json = "application/json"
        case html = "text/html"
        case text = "text/plain"
    }

    var accept: ContentType? {
        get {
            if let value = self[Key.Accept] {
                return ContentType.init(rawValue: value)
            }

            return nil
        }

        set {
            self[Key.Accept] = newValue?.rawValue
        }
    }

    var contentType: ContentType? {
        get {
            if let value = self[Key.ContentType] {
                return ContentType.init(rawValue: value)
            }

            return nil
        }

        set {
            self[Key.ContentType] = newValue?.rawValue
        }
    }

    var authorization: String? {
        get {
            return self[Key.Authorization]
        }

        set {
            self[Key.Authorization] = newValue
        }
    }

    subscript(index: String) -> String? {
        get {
            return self.headers[Key(index)]
        }

        set {
            self.headers[Key(index)] = newValue
        }
    }

    var rawValue: [String: String] {
        var result: [String: String] = [:]
        for (key, value) in self.headers {
            result[key.value] = value
        }
        return result
    }

    private var headers: [Key: String] = [:]

    init() {}

    init(_ headers: HTTPHeaders) {
        self.updateWithHeaders(headers)
    }

    init(_ rawHeaders: [AnyHashable: Any]) {
        self.updateWithRawHeaders(rawHeaders)
    }

    func updateWithHeaders(_ headers: HTTPHeaders) {
        for (key, value) in headers.headers {
            self.headers[key] = value
        }
    }

    func updateWithRawHeaders(_ rawHeaders: [AnyHashable: Any]) {
        for (key, value) in rawHeaders {
            if let key = key as? String, let value = value as? String {
                self.headers[Key(key)] = value
            }
        }
    }

}

func == (lhs: HTTPHeaders.Key, rhs: HTTPHeaders.Key) -> Bool {
    return lhs.value.lowercased() == rhs.value.lowercased()
}
