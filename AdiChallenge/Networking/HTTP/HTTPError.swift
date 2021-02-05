//
//  HTTPError.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 03/02/2021.
//

import Foundation

enum HTTPError: Error {
    case error(Error)
    case unknownError
    case noResponse
    case decodingFailed(Error)

    var localizedDescription: String {
        switch self {
        case .unknownError:
            return R.string.error.network.unknown
        case .noResponse:
            return R.string.error.network.response
        case .error(let error):
            return R.string.error.network.general(error: error)
        case .decodingFailed(let error):
            return R.string.error.network.decoding(error: error)
        }
    }
}
