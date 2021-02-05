//
//  HTTPSession.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 03/02/2021.
//

import Foundation

protocol HTTPSession {
    func execute(_ request: URLRequest, completion: @escaping (HTTPRequestResult) -> Void)
    func invalidate()
}

final class DefaultHTTPSession: HTTPSession {

    private let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func execute(_ request: URLRequest, completion: @escaping (HTTPRequestResult) -> Void) {
        let task = self.session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.error(error)))
            } else {
                guard let response = response as? HTTPURLResponse, let data = data else {
                    completion(.failure(.noResponse))
                    return
                }
                completion(.success(DefaultHTTPResponse(with: response, data: data)))
            }
        }
        task.resume()
    }

    func invalidate() {
        self.session.invalidateAndCancel()
    }
}
