//
//  ReviewTableViewCell.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 04/02/2021.
//

import UIKit

final class ReviewTableViewCell: PressableTableViewCell {

    static let reuseIdentifier = "ReviewTableViewCell"

    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.selectionStyle = .none
    }

    override func didChangePressedTo(_ isPressed: Bool) {
        self.alpha = isPressed ? 0.5 : 1.0
    }

    func setup(with presentable: ReviewPresentable) {
        self.descriptionLabel.text = presentable.description
        self.ratingLabel.text = "\(presentable.rating)"
    }
}
