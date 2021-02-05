//
//  HTTPService.swift
//  AdiChallenge
//
//  Created by Milan Stevanović on 03/02/2021.
//

import Foundation

class HTTPService {

    private let client: HTTPClient
    private let decoder: JSONDecoder

    static private var defaultDecoder: JSONDecoder = {
        $0.dateDecodingStrategy = .secondsSince1970
        return $0
    }(JSONDecoder())

    init(client: HTTPClient, decoder: JSONDecoder = HTTPService.defaultDecoder) {
        self.client = client
        self.decoder = decoder
    }

    func execute<T: Decodable>(_ request: HTTPRequest, completion: @escaping (HTTPResult<T>) -> Void) {

        self.client.execute(request) { [weak self] result in

            guard let self = self else {
                DispatchQueue.main.async {
                    completion(.failure(.unknownError))
                }
                return
            }

            switch result {
            case .success(let response):
                do {
                    let decoded = try self.decoder.decode(T.self, from: response.data)
                    DispatchQueue.main.async {
                        completion(.success(decoded))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(.decodingFailed(error)))
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
