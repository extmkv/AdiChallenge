//
//  HTTPResult.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 03/02/2021.
//

import Foundation

enum HTTPResult<T> {
    case success(T)
    case failure(HTTPError)
}
