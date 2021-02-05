//
//  HTTPRequestTests.swift
//  AdiChallengeTests
//
//  Created by Milan Stevanović on 05/02/2021.
//

import XCTest
@testable import AdiChallenge

final class HTTPRequestTests: XCTestCase {

    private var request: HTTPRequest!

    private let baseURLString = "http://localhost:3001/"
    private let endpoint = "current"

    override func setUpWithError() throws {
        self.request = HTTPRequest(path: .init(self.endpoint), method: .GET)
    }

    override func tearDownWithError() throws {
        self.request = nil
    }

    func testAppendingPathComponents() {

        let key1 = "abc"
        let value1 = "123"

        let key2 = "def"
        let value2 = "456"

        self.request.path.setQueryItem(key1, value: value1)
        self.request.path.setQueryItem(key2, value: value2)

        let expected = self.baseURLString + "\(endpoint)?\(key1)=\(value1)&\(key2)=\(value2)"
        let result = self.request.path.url(relativeTo: URL(string: self.baseURLString)!).absoluteString
        XCTAssertEqual(expected, result)
    }
}
