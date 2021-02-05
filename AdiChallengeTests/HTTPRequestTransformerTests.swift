//
//  HTTPRequestTransformerTests.swift
//  AdiChallengeTests
//
//  Created by Milan Stevanović on 05/02/2021.
//

import XCTest
@testable import AdiChallenge

final class HTTPRequestTransformerTests: XCTestCase {

    private var requestTransformer: HTTPRequestTransformer!

    private let baseURLString = "http://localhost:3001/"

    override func setUpWithError() throws {
        self.requestTransformer = DefaultHTTPRequestTransformer(baseURL: URL(string: self.baseURLString)!)
    }

    override func tearDownWithError() throws {
        self.requestTransformer = nil
    }

    func testAppendingPathComponents() {

        let httpRequest = HTTPRequest(path: .init(self.baseURLString), method: .GET)

        let key1 = "abc"
        let value1 = "123"

        let key2 = "def"
        let value2 = "456"

        httpRequest.path.setQueryItem(key1, value: value1)
        httpRequest.path.setQueryItem(key2, value: value2)

        let urlRequest = self.requestTransformer.urlRequest(from: httpRequest)

        let expected = self.baseURLString + "?\(key1)=\(value1)&\(key2)=\(value2)"
        let result = urlRequest.url!.absoluteString
        XCTAssertEqual(expected, result)
    }
}
