//
//  Product.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 03/02/2021.
//

import Foundation

struct Product: Codable {
    let id: String
    let name: String
    let description: String
    let imgUrl: String
    let currency: String?
    let price: Double?
    let reviews: [Review]?

    init(id: String = UUID().uuidString, name: String, description: String, imgUrl: String) {
        self.id = id
        self.name = name
        self.description = description
        self.imgUrl = imgUrl
        self.currency = nil
        self.price = nil
        self.reviews = nil
    }
}
