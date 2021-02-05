//
//  ViewControllerProvider.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 03/02/2021.
//

import UIKit

protocol ViewControllerProvider {
    func productListViewController() -> UIViewController
    func productDetailsViewController(for presentable: ProductPresentable) -> UIViewController
    func addProductViewController(delegate: AddProductViewControllerDelegate) -> UIViewController
    func addReviewViewController(delegate: AddReviewViewControllerDelegate, productId: String) -> UIViewController
}

final class DefaultViewControllerProvider: ViewControllerProvider {

    unowned private let assembly: Assembly

    init(assembly: Assembly) {
        self.assembly = assembly
    }

    func productListViewController() -> UIViewController {
        let logicController = ProductsLogicController(productService: self.assembly.apiClient.productService, currencyFormatter: .currency())
        let viewController = ProductsViewController(logicController: logicController,
                                                       viewControllerProvider: self.assembly.viewControllerProvider)
        return UINavigationController(rootViewController: viewController)
    }

    func productDetailsViewController(for presentable: ProductPresentable) -> UIViewController {
        let logicController = ProductDetailsLogicController(productPresentable: presentable,
                                                            reviewService: self.assembly.apiClient.reviewService)
        let viewController = ProductDetailsViewController(logicController: logicController,
                                                          viewControllerProvider: self.assembly.viewControllerProvider)
        return viewController
    }

    func addProductViewController(delegate: AddProductViewControllerDelegate) -> UIViewController {
        let logicController = AddProductLogicController(productService: self.assembly.apiClient.productService)
        let viewController = AddProductViewController(logicController: logicController)
        viewController.delegate = delegate
        return viewController
    }

    func addReviewViewController(delegate: AddReviewViewControllerDelegate, productId: String) -> UIViewController {
        let logicController = AddReviewLogicController(reviewService: self.assembly.apiClient.reviewService,
                                                       productId: productId)
        let viewController = AddReviewViewController(logicController: logicController)
        viewController.delegate = delegate
        return viewController
    }
}
