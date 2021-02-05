//
//  HTTPRequestBody.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 03/02/2021.
//

import Foundation

protocol HTTPRequestBody {
    func data() throws -> Data
    func headers() -> HTTPHeaders
}
