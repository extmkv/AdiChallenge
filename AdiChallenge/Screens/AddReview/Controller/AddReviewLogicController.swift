//
//  AddReviewLogicController.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 04/02/2021.
//

import Foundation

final class AddReviewLogicController {

    // MARK: - Events

    typealias OnEvent = ((Event) -> Void)

    enum Event {
        case reviewAdded(review: Review)
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

    private let reviewService: ReviewService
    private let productId: String

    init(reviewService: ReviewService, productId: String) {
        self.reviewService = reviewService
        self.productId = productId
    }

    // MARK: - Actions

    func addReview(description: String, rating: Int) {

        guard !description.isEmpty else {
            self.presenter?.presentAlert(.informative(.init(title: R.string.common.error, message: R.string.error.input.empty)))
            return
        }

        guard self.state != .loading else { return }
        self.state.switchToLoading()

        self.reviewService.addReview(Review(productId: self.productId, rating: rating, text: description)) { [weak self] result in
            switch result {
            case .success(let review):
                self?.state.switchToLoaded()
                self?.onEvent?(.reviewAdded(review: review))
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
