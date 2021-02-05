//
//  BaseViewController.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 03/02/2021.
//

import UIKit

protocol ModalPresenter: class {
    func dismiss(animated flag: Bool, completion: (() -> Void)?)
}

protocol AlertPresenter: class {
    func presentAlert(_ alert: Alert)
}

class BaseViewController: UIViewController, AlertPresenter, ModalPresenter {

    // MARK: - Present

    func presentAlert(_ alert: Alert) {
        switch alert {
        case .informative(let presentable):
            let alertController = UIAlertController(title: presentable.title,
                                                    message: presentable.message,
                                                    preferredStyle: .alert)
            let alertAction = UIAlertAction(title: presentable.buttonTitle,
                                            style: .default,
                                            handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        case .destructive(let presentable):
            let alertController = UIAlertController(title: presentable.title,
                                                    message: presentable.message,
                                                    preferredStyle: .alert)
            let confirmAlertAction = UIAlertAction(title: presentable.confirmButtonTitle,
                                                   style: .destructive,
                                                   handler: { _ in
                                                    presentable.action()
                                                   })
            let cancelAlertAction = UIAlertAction(title: presentable.cancelButtonTitle,
                                                  style: .default,
                                                  handler: nil)
            alertController.addAction(confirmAlertAction)
            alertController.addAction(cancelAlertAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    // MARK: - Lifecycle

    var lifecycleObserver: ViewControllerLifecycleObserver? {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.lifecycleObserver?.viewControllerDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.lifecycleObserver?.viewControllerWillAppear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.lifecycleObserver?.viewControllerDidAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.lifecycleObserver?.viewControllerWillDisappear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.lifecycleObserver?.viewControllerDidDisappear()
    }
}
