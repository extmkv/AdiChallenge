//
//  R.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 03/02/2021.
//

import Foundation

struct R {
    static let config = RConfig.self
    static let string = RString.self
}

enum RConfig {
    static let productURL = "http://localhost:3001/"
    static let reviewURL = "http://localhost:3002/"
}

enum RString {
    static let common = RStringCommon.self
    static let error = RStringError.self
}

enum RStringCommon {
    static let ok = "Ok"
    static let confirm = "Confirm"
    static let cancel = "Cancel"
    static let error = "Error"
    static let notApplicable = "N/A"
}

enum RStringError {

    enum input {
        static let empty = "Empty fields not allowed!"
    }

    private static func formattedError(domain: String, description: String, error: Error? = nil) -> String {
        if let error = error {
            return "[\(domain)] Reason: \(description); Error: '\(error)'"
        } else {
            return "[\(domain)] Reason: \(description)"
        }

    }

    enum network {
        static let unknown: String = formattedError(domain: "HTTPError", description: "Request failed with unknown error")
        static let response: String = formattedError(domain: "HTTPError", description: "There was no response")
        static func general(error: Error) -> String {
            return formattedError(domain: "HTTPError", description: "Request failed", error: error)
        }
        static func decoding(error: Error) -> String {
            return formattedError(domain: "HTTPError", description: "Decoding json failed", error: error)
        }
    }
}
