//
//  ProductTableViewCell.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 03/02/2021.
//

import UIKit
import Kingfisher

final class ProductTableViewCell: PressableTableViewCell {

    static let reuseIdentifier = "ProductTableViewCell"

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var productImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.selectionStyle = .none
    }

    override func didChangePressedTo(_ isPressed: Bool) {
        self.alpha = isPressed ? 0.5 : 1.0
    }

    func setup(with presentable: ProductPresentable) {
        self.titleLabel.text = presentable.name
        self.subtitleLabel.text = presentable.description
        self.priceLabel.text = presentable.price
        guard let imageURL = presentable.imageURL else { return }
        self.productImageView.kf.setImage(with: imageURL)
    }
}
