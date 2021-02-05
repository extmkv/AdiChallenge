//
//  NumberFormatter+Currency.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 05/02/2021.
//

import Foundation

extension NumberFormatter {

    static func currency() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.roundingMode = .down
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }
}
