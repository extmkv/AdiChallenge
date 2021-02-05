//
//  Review.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 03/02/2021.
//

import Foundation

struct Review: Codable {
    let productId: String
    let locale: String
    let rating: Int
    let text: String

    init(productId: String, locale: String = "en-US", rating: Int, text: String) {
        self.productId = productId
        self.locale = locale
        self.rating = rating
        self.text = text
    }
}
