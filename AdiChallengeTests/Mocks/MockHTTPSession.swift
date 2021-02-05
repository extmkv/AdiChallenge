//
//  MockHTTPSession.swift
//  AdiChallengeTests
//
//  Created by Milan Stevanović on 05/02/2021.
//

import Foundation
@testable import AdiChallenge

final class MockHTTPSession: HTTPSession {

    func execute(_ request: URLRequest, completion: @escaping (HTTPRequestResult) -> Void) {
        let data = request.url!.absoluteString.data(using: .utf8)!
        completion(.success(DefaultHTTPResponse.init(statusCode: 200, headers: HTTPHeaders(), data: data)))
    }

    func invalidate() {}
}
