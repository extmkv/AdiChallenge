//
//  ReviewPresentable.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 04/02/2021.
//

import Foundation

struct ReviewPresentable {

    let productId: String
    let rating: Int
    let description: String

    init(productId: String = UUID().uuidString, rating: Int = 10, description: String = "💎🤲🦍💪🚀") {
        self.productId = productId
        self.rating = rating
        self.description = description
    }

    init(review: Review) {
        self.productId = review.productId
        self.rating = review.rating
        self.description = review.text
    }
}
