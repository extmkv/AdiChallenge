//
//  ProductsLogicControllerTests.swift
//  AdiChallengeTests
//
//  Created by Milan Stevanović on 05/02/2021.
//

import XCTest
@testable import AdiChallenge

final class ProductsLogicControllerTests: XCTestCase {

    private var logicController: ProductsLogicController!
    private var service: MockProductService!

    override func setUpWithError() throws {
        self.service = MockProductService()
        self.logicController = ProductsLogicController(productService: self.service, currencyFormatter: .currency())
    }

    override func tearDownWithError() throws {
        self.logicController = nil
        self.service = nil
    }

    func testLoadingProducts() {
        let products = ["1", "2", "3"].map { Product(name: $0, description: $0, imgUrl: $0) }
        self.service.allProducts = products

        let eventExpectation = self.expectation(description: "eventExpectation")
        eventExpectation.expectedFulfillmentCount = 1

        self.logicController.onEvent = { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .productsLoaded:
                XCTAssertEqual(self.logicController.numberOfRows(), products.count)
                for index in 0...products.count-1 {
                    XCTAssertEqual(self.logicController.presentable(for: index).name, products[index].name)
                }
                eventExpectation.fulfill()
            default:
                XCTFail()
            }
        }

        self.logicController.viewControllerWillAppear()

        self.waitForExpectations(timeout: 0.0, handler: nil)
    }

    func testAddingProduct() {

        let products = ["1", "2"].map { Product(name: $0, description: $0, imgUrl: $0) }
        self.service.allProducts = products

        let eventExpectation = self.expectation(description: "eventExpectation")
        eventExpectation.expectedFulfillmentCount = 2

        var count = 0

        let addedProduct = Product(name: "3", description: "3", imgUrl: "3")

        self.logicController.onEvent = { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .productsLoaded:
                if count == 0 {
                    XCTAssertEqual(self.logicController.numberOfRows(), products.count)
                } else {
                    XCTAssertEqual(self.logicController.numberOfRows(), products.count + 1)
                    XCTAssertEqual(self.logicController.presentable(for: self.logicController.numberOfRows()-1).name, addedProduct.name)
                }
                count += 1
                eventExpectation.fulfill()
            default:
                XCTFail()
            }
        }

        self.logicController.viewControllerWillAppear()
        self.logicController.addProduct(addedProduct)

        self.waitForExpectations(timeout: 0.0, handler: nil)
    }

    func testDeletingProduct() {

        let products = ["1", "2", "3"].map { Product(name: $0, description: $0, imgUrl: $0) }
        self.service.allProducts = products

        let eventExpectation = self.expectation(description: "eventExpectation")
        eventExpectation.expectedFulfillmentCount = 2

        self.logicController.onEvent = { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .productsLoaded:
                eventExpectation.fulfill()
            case .productDeleted:
                XCTAssertEqual(self.logicController.numberOfRows(), 2)
                eventExpectation.fulfill()
            default:
                XCTFail()
            }
        }

        self.logicController.viewControllerWillAppear()

        self.logicController.deleteProduct(at: 2)

        self.waitForExpectations(timeout: 0.0, handler: nil)
    }

    func testFiltering() {

        let products = ["1", "2", "3"].map { Product(name: $0, description: $0, imgUrl: $0) }
        self.service.allProducts = products

        let eventExpectation = self.expectation(description: "eventExpectation")
        eventExpectation.expectedFulfillmentCount = 2

        var count = 0

        self.logicController.onEvent = { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .productsLoaded:
                if count == 0 {
                    XCTAssertEqual(self.logicController.numberOfRows(), products.count)
                } else {
                    XCTAssertEqual(self.logicController.numberOfRows(), 1)
                    XCTAssertEqual(self.logicController.presentable(for: 0).name, "3")
                }
                count += 1
                eventExpectation.fulfill()
            default:
                XCTFail()
            }
        }

        self.logicController.viewControllerWillAppear()
        self.logicController.setFilter("3")

        self.waitForExpectations(timeout: 0.0, handler: nil)
    }

    func testSelectingProduct() {

        let products = ["1", "2", "3"].map { Product(name: $0, description: $0, imgUrl: $0) }
        self.service.allProducts = products

        let eventExpectation = self.expectation(description: "eventExpectation")
        eventExpectation.expectedFulfillmentCount = 2

        self.logicController.onEvent = { event in
            switch event {
            case .productsLoaded:
                eventExpectation.fulfill()
            case .productSelected(let presentable):
                eventExpectation.fulfill()
                XCTAssertEqual(presentable.name, "3")
            default:
                XCTFail()
            }
        }

        self.logicController.viewControllerWillAppear()
        self.logicController.selectProduct(at: products.count-1)

        self.waitForExpectations(timeout: 0.0, handler: nil)
    }

}
