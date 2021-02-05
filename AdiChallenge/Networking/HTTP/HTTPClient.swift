//
//  HTTPClient.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 03/02/2021.
//

import Foundation

protocol HTTPClient {
    func execute(_ request: HTTPRequest, completion: @escaping (HTTPRequestResult) -> Void)
}

final class DefaultHTTPClient: HTTPClient {

    private let session: HTTPSession
    private let requestTransformer: HTTPRequestTransformer

    init(session: HTTPSession, requestTransformer: HTTPRequestTransformer) {
        self.session = session
        self.requestTransformer = requestTransformer
    }

    deinit {
        self.session.invalidate()
    }

    func execute(_ request: HTTPRequest, completion: @escaping (HTTPRequestResult) -> Void) {
        let urlRequest = self.requestTransformer.urlRequest(from: request)
        self.session.execute(urlRequest, completion: completion)
    }
}
