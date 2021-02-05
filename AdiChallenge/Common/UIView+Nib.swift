//
//  UIView+Nib.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 03/02/2021.
//

import UIKit

extension UIView {
    static func fromNib() -> Self {
        func fromNib<T: UIView>() -> T {
            guard let view = UINib(nibName: String(describing: T.self), bundle: nil).instantiate(withOwner: nil, options: nil).first as? T else {
                fatalError("Nib couldn't be found!")
            }

            return view
        }

        return fromNib()
    }
}
