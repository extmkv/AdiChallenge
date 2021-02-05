//
//  File.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 03/02/2021.
//

import Foundation

struct ProductPresentable {
    let id: String
    let name: String
    let description: String
    let imageURL: URL?
    let price: String?

    init(product: Product, currencyFormatter: NumberFormatter) {
        self.id = product.id
        self.name = product.name
        self.description = product.description
        currencyFormatter.currencySymbol = {
            guard let currency = product.currency else { return "€" }
            return currency.isEmpty ? "€" : currency
        }()
        self.price = currencyFormatter.string(from: NSNumber(floatLiteral: product.price ?? 0.0)) ?? "€0.00"
        self.imageURL = URL(string: product.imgUrl)
    }

    init(id: String = UUID().uuidString, name: String = "Name", description: String = "Description", price: String = "€100.00") {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.imageURL = nil
    }
}

extension ProductPresentable: Equatable {
    static func == (lhs: ProductPresentable, rhs: ProductPresentable) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.description == rhs.description && lhs.imageURL == rhs.imageURL && lhs.price == rhs.price
    }
}
