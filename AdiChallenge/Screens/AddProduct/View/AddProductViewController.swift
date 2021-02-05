//
//  AddProductViewController.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 04/02/2021.
//

import UIKit

protocol AddProductViewControllerDelegate: class {
    func addProductViewController(_ viewController: AddProductViewController, didAdd product: Product)
}

final class AddProductViewController: BaseViewController {

    weak var delegate: AddProductViewControllerDelegate?

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var descriptionTextField: UITextField!
    @IBOutlet private weak var imageURLTextField: UITextField!

    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    private let logicController: AddProductLogicController

    init(logicController: AddProductLogicController) {
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
            case .productAdded(let product):
                self.delegate?.addProductViewController(self, didAdd: product)
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
        self.logicController.addProduct(name: self.nameTextField.text ?? "",
                                        description: self.descriptionTextField.text ?? "",
                                        imgUrl: self.imageURLTextField.text ?? "")
    }
}

extension AddProductViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.nameTextField {
            return self.descriptionTextField.becomeFirstResponder()
        } else if textField == self.descriptionTextField {
            return self.imageURLTextField.becomeFirstResponder()
        } else {
            return textField.resignFirstResponder()
        }
    }
}
