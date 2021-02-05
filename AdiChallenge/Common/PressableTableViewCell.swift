//
//  PressableTableViewCell.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 03/02/2021.
//

import UIKit

class PressableTableViewCell: UITableViewCell {

    private static let animationDuration: TimeInterval = 0.3

    var animatedAutomatically: Bool {
        return true
    }

    private var isPressed = false {
        didSet {
            if self.animatedAutomatically {
                UIView.animate(withDuration: PressableTableViewCell.animationDuration) {
                    self.didChangePressedTo(self.isPressed)
                }
            } else {
                self.didChangePressedTo(self.isPressed)
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.isPressed = true
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.isPressed = false
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.isPressed = false
    }

    func didChangePressedTo(_ isPressed: Bool) {}
}
