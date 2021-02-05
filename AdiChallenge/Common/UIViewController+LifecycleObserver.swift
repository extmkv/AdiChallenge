//
//  UIViewController+LifecycleObserver.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 03/02/2021.
//

import Foundation

protocol ViewControllerLifecycleObserver: class {
    func viewControllerWillAppear()
    func viewControllerWillDisappear()
    func viewControllerDidAppear()
    func viewControllerDidDisappear()
    func viewControllerDidLoad()
}
