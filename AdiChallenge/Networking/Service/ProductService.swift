//
//  ProductService.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 03/02/2021.
//

import Foundation

protocol ProductService {
    func getAllProducts(completion: @escaping (HTTPResult<[Product]>) -> Void)
    func getProduct(with id: String, completion: @escaping (HTTPResult<[Product]>) -> Void)
    func addProduct(_ product: Product, completion: @escaping (HTTPResult<Product>) -> Void)
    func updateProduct(_ product: Product, completion: @escaping (HTTPResult<Product>) -> Void)
    func deleteProduct(with id: String, completion: @escaping (HTTPResult<GenericResponse>) -> Void)
}

final class DefaultProductService: HTTPService, ProductService {

    func getAllProducts(completion: @escaping (HTTPResult<[Product]>) -> Void) {
        let path = HTTPRequest.Path("/product")
        let request = HTTPRequest(path: path, method: .GET)
        self.execute(request, completion: completion)
    }

    func getProduct(with id: String, completion: @escaping (HTTPResult<[Product]>) -> Void) {
        let path = HTTPRequest.Path("/product/\(id)")
        let request = HTTPRequest(path: path, method: .GET)
        self.execute(request, completion: completion)
    }

    func addProduct(_ product: Product, completion: @escaping (HTTPResult<Product>) -> Void) {
        let path = HTTPRequest.Path("/product")
        let request = HTTPRequest(path: path, method: .POST)
        request.body = HTTPRequestJSONBody(product)
        self.execute(request, completion: completion)
    }

    func updateProduct(_ product: Product, completion: @escaping (HTTPResult<Product>) -> Void) {
        let path = HTTPRequest.Path("/product/\(product.id)")
        let request = HTTPRequest(path: path, method: .PUT)
        request.body = HTTPRequestJSONBody(product)
        self.execute(request, completion: completion)
    }

    func deleteProduct(with id: String, completion: @escaping (HTTPResult<GenericResponse>) -> Void) {
        let path = HTTPRequest.Path("/product/\(id)")
        let request = HTTPRequest(path: path, method: .DELETE)
        self.execute(request, completion: completion)
    }
}
