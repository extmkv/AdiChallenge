//
//  Assembly.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 03/02/2021.
//

import UIKit

protocol Assembly: class {
    var apiClient: APIClient { get }
    var viewControllerProvider: ViewControllerProvider { get }
    var rootViewController: UIViewController { get }
}

final class DefaultAssembly: Assembly {

    let apiClient: APIClient

    init(urlSession: URLSession) {
        self.apiClient = DefaultAPIClient(httpSession: DefaultHTTPSession(session: urlSession))
    }

    private(set) lazy var viewControllerProvider: ViewControllerProvider = DefaultViewControllerProvider(assembly: self)
    private(set) lazy var rootViewController: UIViewController = self.viewControllerProvider.productListViewController()
}
