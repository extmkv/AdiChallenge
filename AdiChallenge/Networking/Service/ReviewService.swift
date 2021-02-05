//
//  ReviewService.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 03/02/2021.
//

import Foundation

protocol ReviewService {
    func getReviews(forProductWithId id: String, completion: @escaping (HTTPResult<[Review]>) -> Void)
    func addReview(_ review: Review, completion: @escaping (HTTPResult<Review>) -> Void)
}

final class DefaultReviewService: HTTPService, ReviewService {

    func getReviews(forProductWithId id: String, completion: @escaping (HTTPResult<[Review]>) -> Void) {
        let path = HTTPRequest.Path("/reviews/\(id)")
        let request = HTTPRequest(path: path, method: .GET)
        self.execute(request, completion: completion)
    }

    func addReview(_ review: Review, completion: @escaping (HTTPResult<Review>) -> Void) {
        let path = HTTPRequest.Path("/reviews/\(review.productId)")
        let request = HTTPRequest(path: path, method: .POST)
        request.body = HTTPRequestJSONBody(review)
        self.execute(request, completion: completion)
    }
}
