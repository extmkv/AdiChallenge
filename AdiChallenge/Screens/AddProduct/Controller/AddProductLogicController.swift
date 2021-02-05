//
//  AddProductLogicController.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 04/02/2021.
//

import Foundation

final class AddProductLogicController {

    // MARK: - Events

    typealias OnEvent = ((Event) -> Void)

    enum Event {
        case productAdded(product: Product)
    }

    var onEvent: OnEvent?

    var onStateChanged: OnLogicControllerStateChanged?

    private var state: LogicControllerState = .loaded {
        didSet {
            self.onStateChanged?(self.state)
        }
    }

    weak var presenter: (AlertPresenter & ModalPresenter)?

    // MARK: - Init

    private let productService: ProductService

    init(productService: ProductService) {
        self.productService = productService
    }

    // MARK: - Actions

    func addProduct(name: String, description: String, imgUrl: String) {

        guard !name.isEmpty, !description.isEmpty, !imgUrl.isEmpty else {
            self.presenter?.presentAlert(.informative(.init(title: R.string.common.error, message: R.string.error.input.empty)))
            return
        }

        guard self.state != .loading else { return }
        self.state.switchToLoading()
        self.productService.addProduct(Product(name: name, description: description, imgUrl: imgUrl)) { [weak self] result in
            switch result {
            case .success(let product):
                self?.state.switchToLoaded()
                self?.onEvent?(.productAdded(product: product))
                self?.presenter?.dismiss(animated: true, completion: nil)
            case .failure(let error):
                self?.handleError(error)
            }
        }
    }

    private func handleError(_ error: Error) {
        guard self.state == .loading else { return}
        self.state.switchToLoaded()
        self.presenter?.presentAlert(.informative(.error(error)))
    }
}
