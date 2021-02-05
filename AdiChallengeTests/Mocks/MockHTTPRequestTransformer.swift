//
//  MockHTTPRequestTransformer.swift
//  AdiChallengeTests
//
//  Created by Milan Stevanović on 05/02/2021.
//

import Foundation
@testable import AdiChallenge

final class MockHTTPRequestTransformer: HTTPRequestTransformer {

    var urlRequest: URLRequest!

    func urlRequest(from httpRequest: HTTPRequest) -> URLRequest {
        return self.urlRequest
    }
}
