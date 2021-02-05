//
//  ProductDetailsViewController.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 03/02/2021.
//

import UIKit

final class ProductDetailsViewController: BaseViewController {

    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    @IBOutlet private weak var imageView: UIImageView! {
        didSet {
            self.imageView.layer.borderWidth = 3
            self.imageView.layer.masksToBounds = false
            self.imageView.layer.borderColor = UIColor.black.cgColor
            self.imageView.clipsToBounds = true
        }
    }

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self

            let cellNib = UINib(nibName: ReviewTableViewCell.reuseIdentifier, bundle: nil)
            self.tableView.register(cellNib, forCellReuseIdentifier: ReviewTableViewCell.reuseIdentifier)
        }
    }

    private lazy var templateCell = ReviewTableViewCell.fromNib()

    private lazy var templateCellHeight: CGFloat = {
        self.templateCell.setup(with: ReviewPresentable())
        self.templateCell.layoutIfNeeded()
        return self.templateCell.contentView.systemLayoutSizeFitting(self.templateCell.bounds.size).height
    }()

    // MARK: - Init

    private let logicController: ProductDetailsLogicController
    private let viewControllerProvider: ViewControllerProvider

    init(logicController: ProductDetailsLogicController, viewControllerProvider: ViewControllerProvider) {
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
            case .reviewSelected:
                break
            case .reviewsLoaded:
                self.tableView.reloadData()
            case .productLoaded(let presentable):
                self.nameLabel.text = presentable.name
                self.descriptionLabel.text = presentable.description
                self.priceLabel.text = presentable.price
                guard let imageURL = presentable.imageURL else { return }
                self.imageView.kf.setImage(with: imageURL)
            case .newReview(let productId):
                let viewController = self.viewControllerProvider.addReviewViewController(delegate: self, productId: productId)
                self.present(viewController, animated: true, completion: nil)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.imageView.layer.cornerRadius = self.imageView.bounds.height / 2
    }

    // MARK: - Actions

    @objc private func didPressAddButton() {
        self.logicController.startNewReview()
    }
}

// MARK: - UITableViewDataSource

extension ProductDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.logicController.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? ReviewTableViewCell else {
            fatalError("🛑 Couldn't deque ReviewTableViewCell")
        }
        let presentable = self.logicController.presentable(for: indexPath.row)
        cell.setup(with: presentable)
        return cell
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
}

// MARK: - UITableViewDelegate

extension ProductDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.templateCellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.logicController.selectReview(at: indexPath.row)
    }
}

extension ProductDetailsViewController: AddReviewViewControllerDelegate {
    func addReviewViewController(_ viewController: AddReviewViewController, didAdd review: Review) {
        self.logicController.addReview(review)
    }
}
