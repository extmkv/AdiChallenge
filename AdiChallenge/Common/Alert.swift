//
//  Alert.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 03/02/2021.
//

import Foundation

enum Alert {
    case informative(InformativeAlertPresentable)
    case destructive(DestructiveAlertPresentable)

    struct InformativeAlertPresentable {

        let title: String
        let message: String
        let buttonTitle: String

        init(title: String, message: String, buttonTitle: String = R.string.common.ok) {
            self.title = title
            self.message = message
            self.buttonTitle = buttonTitle
        }

        static func error(_ error: Error) -> InformativeAlertPresentable {
            return InformativeAlertPresentable(title: R.string.common.error,
                                               message: error.localizedDescription)
        }
    }

    struct DestructiveAlertPresentable {

        let title: String
        let message: String
        let confirmButtonTitle: String
        let cancelButtonTitle: String
        let action: () -> Void

        init(title: String,
             message: String,
             buttonTitle: String = R.string.common.confirm,
             cancelButtonTitle: String = R.string.common.cancel,
             action: @escaping () -> Void) {
            self.title = title
            self.message = message
            self.confirmButtonTitle = buttonTitle
            self.cancelButtonTitle = cancelButtonTitle
            self.action = action
        }
    }
}
