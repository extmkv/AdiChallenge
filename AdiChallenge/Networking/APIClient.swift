//
//  APIClient.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 03/02/2021.
//

import Foundation

protocol APIClient {
    var productService: ProductService { get }
    var reviewService: ReviewService { get }
}

final class DefaultAPIClient: APIClient {

    private let httpSession: HTTPSession

    init(httpSession: HTTPSession) {
        self.httpSession = httpSession
    }

    private(set) lazy var productService: ProductService = DefaultProductService(client: DefaultHTTPClient(session: self.httpSession,
                                                                                                           requestTransformer: self.requestTransformer(for: R.config.productURL)))

    private(set) lazy var reviewService: ReviewService = DefaultReviewService(client: DefaultHTTPClient(session: self.httpSession,
                                                                                                        requestTransformer: self.requestTransformer(for: R.config.reviewURL)))

    private func requestTransformer(for baseURLString: String) -> HTTPRequestTransformer {
        return DefaultHTTPRequestTransformer(baseURL: URL(string: baseURLString).require())
    }
}
