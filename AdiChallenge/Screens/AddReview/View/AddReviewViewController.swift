//
//  AddReviewViewController.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 04/02/2021.
//

import UIKit

protocol AddReviewViewControllerDelegate: class {
    func addReviewViewController(_ viewController: AddReviewViewController, didAdd review: Review)
}

final class AddReviewViewController: BaseViewController {

    weak var delegate: AddReviewViewControllerDelegate?

    @IBOutlet private weak var descriptionTextField: UITextField!
    @IBOutlet private weak var ratingSlider: UISlider! {
        didSet {
            self.ratingSlider.maximumValue = 10
            self.ratingSlider.minimumValue = 1
        }
    }
    @IBOutlet private weak var ratingLabel: UILabel!

    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    private let logicController: AddReviewLogicController

    init(logicController: AddReviewLogicController) {
        self.logicController = logicController
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupBindings()
    }

    // MARK: - Bindings

    private func setupBindings() {

        self.logicController.presenter = self

        self.logicController.onEvent = { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .reviewAdded(let review):
                self.delegate?.addReviewViewController(self, didAdd: review)
            }
        }

        self.logicController.onStateChanged = { [weak self] state in
            switch state {
            case .loading:
                self?.activityIndicatorView.startAnimating()
            case .loaded:
                self?.activityIndicatorView.stopAnimating()
            }
        }
    }

    // MARK: - Actions

    @IBAction private func didPressButton() {
        self.logicController.addReview(description: self.descriptionTextField.text ?? "", rating: Int(self.ratingSlider.value))
    }
    
    @IBAction func sliderDidChangeValue(_ sender: UISlider) {
        self.ratingLabel.text = "\(Int(sender.value))"
    }
}

extension AddReviewViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
