//
//  LogicControllerState.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 04/02/2021.
//

import Foundation

typealias OnLogicControllerStateChanged = ((LogicControllerState) -> Void)

enum LogicControllerState {
    case loading
    case loaded

    mutating func switchToLoading() {
        self = .loading
    }

    mutating func switchToLoaded() {
        self = .loaded
    }
}
