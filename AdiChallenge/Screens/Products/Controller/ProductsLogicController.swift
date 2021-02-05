//
//  ProductsLogicController.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 03/02/2021.
//

import Foundation

final class ProductsLogicController {

    // MARK: - Events

    typealias OnEvent = ((Event) -> Void)

    enum Event {
        case productsLoaded
        case productDeleted(row: Int)
        case productSelected(presentable: ProductPresentable)
    }

    var onEvent: OnEvent?
    var onStateChanged: OnLogicControllerStateChanged?

    private var state: LogicControllerState = .loaded {
        didSet {
            self.onStateChanged?(self.state)
        }
    }

    weak var presenter: AlertPresenter?

    // MARK: - Init

    private let productService: ProductService
    private let currencyFormatter: NumberFormatter

    init(productService: ProductService, currencyFormatter: NumberFormatter) {
        self.productService = productService
        self.currencyFormatter = currencyFormatter
    }

    // MARK: - Table View Data

    private var presentables: [ProductPresentable] = []

    private var filter: String?
    private var filteredPresentables: [ProductPresentable] {
        guard let filter = filter else { return self.presentables }
        return self.presentables.filter {
            $0.name.contains(filter) || $0.description.contains(filter)
        }
    }

    func numberOfRows() -> Int {
        return self.filteredPresentables.count
    }

    func presentable(for row: Int) -> ProductPresentable {
        return self.filteredPresentables[row]
    }

    // MARK: - Actions

    func addProduct(_ product: Product) {
        self.presentables.append(ProductPresentable(product: product, currencyFormatter: self.currencyFormatter))
        self.onEvent?(.productsLoaded)
    }

    func deleteProduct(at row: Int) {
        guard self.state != .loading else { return }

        self.state.switchToLoading()

        let filteredPresentable = self.filteredPresentables[row]

        self.productService.deleteProduct(with: filteredPresentable.id) { [weak self] result in
            switch result {
            case .success:
                self?.presentables.removeAll(where: {
                    $0 == filteredPresentable
                })
                self?.onEvent?(.productDeleted(row: row))
                self?.state.switchToLoaded()
            case .failure(let error):
                self?.handleError(error)
            }
        }
    }

    func selectProduct(at row: Int) {
        self.onEvent?(.productSelected(presentable: self.presentables[row]))
    }

    func setFilter(_ filter: String) {
        self.filter = filter.isEmpty ? nil : filter
        self.onEvent?(.productsLoaded)
    }

    private func loadProducts() {
        guard self.state != .loading else { return }

        self.state.switchToLoading()

        self.productService.getAllProducts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let products):
                self.presentables = products.map { ProductPresentable(product: $0, currencyFormatter: self.currencyFormatter) }
                self.onEvent?(.productsLoaded)
                self.state.switchToLoaded()
            case .failure(let error):
                self.handleError(error)
            }
        }
    }

    private func handleError(_ error: Error) {
        guard self.state == .loading else { return}
        self.state.switchToLoaded()
        self.presenter?.presentAlert(.informative(.error(error)))
    }
}

// MARK: - ViewControllerLifecycleObserver

extension ProductsLogicController: ViewControllerLifecycleObserver {

    func viewControllerWillAppear() {
        self.loadProducts()
    }

    func viewControllerWillDisappear() {

    }

    func viewControllerDidAppear() {

    }

    func viewControllerDidDisappear() {

    }

    func viewControllerDidLoad() {

    }
}
