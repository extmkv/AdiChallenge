//
//  HTTPClientTests.swift
//  AdiChallengeTests
//
//  Created by Milan Stevanović on 05/02/2021.
//

import XCTest
@testable import AdiChallenge

final class HTTPClientTests: XCTestCase {

    private var client: DefaultHTTPClient!
    private var requestTransformer: MockHTTPRequestTransformer!
    private var session: MockHTTPSession!

    private let baseURLString = "http://localhost:3001/"

    override func setUpWithError() throws {
        self.session = MockHTTPSession()
        self.requestTransformer = MockHTTPRequestTransformer()
        self.client = DefaultHTTPClient(session: self.session, requestTransformer: self.requestTransformer)
    }

    override func tearDownWithError() throws {
        self.client = nil
        self.requestTransformer = nil
        self.session = nil
    }

    func testPassingURLRequestToSession() {

        let httpRequest = HTTPRequest(path: .init(self.baseURLString), method: .GET)

        self.requestTransformer.urlRequest = URLRequest(url: URL(string: self.baseURLString)!)

        self.client.execute(httpRequest) { result in
            switch result {
            case .success(let response):
                let expected = self.baseURLString
                let result = String(bytes: response.data, encoding: .utf8)!
                XCTAssertEqual(expected, result)
            case .failure:
                XCTFail()
            }
        }
    }

}
