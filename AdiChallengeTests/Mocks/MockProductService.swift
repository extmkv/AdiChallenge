//
//  MockProductService.swift
//  AdiChallengeTests
//
//  Created by Milan Stevanović on 05/02/2021.
//

import Foundation
@testable import AdiChallenge

final class MockProductService: ProductService {

    var allProducts: [Product]?

    func getAllProducts(completion: @escaping (HTTPResult<[Product]>) -> Void) {
        guard let allProducts = self.allProducts else { return }
        completion(HTTPResult.success(allProducts))
    }

    func getProduct(with id: String, completion: @escaping (HTTPResult<[Product]>) -> Void) {

    }

    func addProduct(_ product: Product, completion: @escaping (HTTPResult<Product>) -> Void) {

    }

    func updateProduct(_ product: Product, completion: @escaping (HTTPResult<Product>) -> Void) {

    }

    func deleteProduct(with id: String, completion: @escaping (HTTPResult<GenericResponse>) -> Void) {
        self.allProducts?.removeAll(where: { $0.id == id })
        completion(.success(GenericResponse(ok: 0)))
    }
}
