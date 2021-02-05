//
//  ProductsViewController.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 03/02/2021.
//

import UIKit

final class ProductsViewController: BaseViewController {

    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    @IBOutlet private weak var searchBar: UISearchBar!

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self

            let cellNib = UINib(nibName: ProductTableViewCell.reuseIdentifier, bundle: nil)
            self.tableView.register(cellNib, forCellReuseIdentifier: ProductTableViewCell.reuseIdentifier)
        }
    }

    private lazy var templateCell = ProductTableViewCell.fromNib()

    private lazy var templateCellHeight: CGFloat = {
        self.templateCell.setup(with: ProductPresentable())
        self.templateCell.layoutIfNeeded()
        return self.templateCell.contentView.systemLayoutSizeFitting(self.templateCell.bounds.size).height
    }()

    // MARK: - Init

    private let logicController: ProductsLogicController
    private let viewControllerProvider: ViewControllerProvider

    init(logicController: ProductsLogicController, viewControllerProvider: ViewControllerProvider) {
        self.logicController = logicController
        self.viewControllerProvider = viewControllerProvider
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override var lifecycleObserver: ViewControllerLifecycleObserver? {
        return self.logicController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didPressAddButton))

        self.setupBindings()
    }

    // MARK: - Actions

    @objc private func didPressAddButton() {
        let viewController = self.viewControllerProvider.addProductViewController(delegate: self)
        self.present(viewController, animated: true, completion: nil)
    }

    // MARK: - Bindings

    private func setupBindings() {

        self.logicController.presenter = self

        self.logicController.onStateChanged = { [weak self] state in
            switch state {
            case .loading:
                self?.activityIndicatorView.startAnimating()
            case .loaded:
                self?.activityIndicatorView.stopAnimating()
            }
        }

        self.logicController.onEvent = { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .productsLoaded:
                self.tableView.reloadData()
            case .productDeleted(let row):
                self.tableView.deleteRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
            case .productSelected(let presentable):
                let viewController = self.viewControllerProvider.productDetailsViewController(for: presentable)
                self.show(viewController, sender: self)
            }
        }
    }
}

// MARK: - UISearchBarDelegate

extension ProductsViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.logicController.setFilter(searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        let emptyText = ""
        self.searchBar.text = emptyText
        self.logicController.setFilter(emptyText)
        self.searchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource

extension ProductsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.logicController.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? ProductTableViewCell else {
            fatalError("🛑 Couldn't deque ProductTableViewCell")
        }
        let presentable = self.logicController.presentable(for: indexPath.row)
        cell.setup(with: presentable)
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        self.logicController.deleteProduct(at: indexPath.row)
    }
}

// MARK: - UITableViewDelegate

extension ProductsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.templateCellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.logicController.selectProduct(at: indexPath.row)
    }
}

// MARK: - AddProductViewControllerDelegate

extension ProductsViewController: AddProductViewControllerDelegate {

    func addProductViewController(_ viewController: AddProductViewController, didAdd product: Product) {
        self.logicController.addProduct(product)
    }
}
