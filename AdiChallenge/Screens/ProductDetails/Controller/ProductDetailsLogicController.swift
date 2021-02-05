//
//  ProductDetailsLogicController.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 03/02/2021.
//

import Foundation

final class ProductDetailsLogicController {

    // MARK: - Events

    typealias OnEvent = ((Event) -> Void)

    enum Event {
        case productLoaded(presentable: ProductPresentable)
        case reviewSelected(presentable: ReviewPresentable)
        case newReview(productId: String)
        case reviewsLoaded
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

    private let productPresentable: ProductPresentable
    private let reviewService: ReviewService

    init(productPresentable: ProductPresentable, reviewService: ReviewService) {
        self.productPresentable = productPresentable
        self.reviewService = reviewService
    }

    // MARK: - Table View Data

    private var presentables: [ReviewPresentable] = []

    func numberOfRows() -> Int {
        return self.presentables.count
    }

    func presentable(for row: Int) -> ReviewPresentable {
        return self.presentables[row]
    }

    // MARK: - Actions

    private func loadReviews() {
        guard self.state != .loading else { return }

        self.state.switchToLoading()

        self.reviewService.getReviews(forProductWithId: self.productPresentable.id) { [weak self] result in
            switch result {
            case .success(let reviews):
                self?.presentables = reviews.map { ReviewPresentable(review: $0) }
                self?.onEvent?(.reviewsLoaded)
                self?.state.switchToLoaded()
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

    func selectReview(at row: Int) {
        self.onEvent?(.reviewSelected(presentable: self.presentables[row]))
    }

    func addReview(_ review: Review) {
        self.presentables.append(ReviewPresentable(review: review))
        self.onEvent?(.reviewsLoaded)
    }

    func startNewReview() {
        self.onEvent?(.newReview(productId: self.productPresentable.id))
    }
    
}

// MARK: - ViewControllerLifecycleObserver

extension ProductDetailsLogicController: ViewControllerLifecycleObserver {

    func viewControllerWillAppear() {
        self.onEvent?(.productLoaded(presentable: self.productPresentable))
        self.loadReviews()
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
