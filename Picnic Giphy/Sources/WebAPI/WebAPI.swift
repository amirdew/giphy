//
//  WebAPI.swift
//  Picnic Giphy
//
//  Created by Amir on 26/10/2019.
//  Copyright © 2019 Amir. All rights reserved.
//

import Foundation
import Combine

class WebAPI {
    
    // MARK: Properties
    
    private let session: URLSession
    private let apiKey = "dc6zaTOxFJmzC"
    private let jsonDecoder: JSONDecoder
    
    
    // MARK: Lifecycle
    
    init(session: URLSession = .shared) {
        self.session = session
        self.jsonDecoder = JSONDecoder()
    }
    
    
    // MARK: Public functions
    
    func request<ResponseType: Decodable>(endPoint: Endpoint) -> AnyPublisher<ResponseType, Error> {
        let url: URL
        do {
            url = try endPoint.asURL(apiKey: apiKey)
        } catch {
            return Future<ResponseType, Error> { $0(.failure(error)) }.eraseToAnyPublisher()
        }
        return performRequest(for: url)
            .tryMap { [weak self] in
                guard let self = self else {
                    throw CombineError.released
                }
                return try self.jsonDecoder.decode(ResponseType.self, from: $0.data)
            }
            .eraseToAnyPublisher()
    }
    
    func downloadPublicData(url: URL) -> AnyPublisher<Data, URLError> {
        return performRequest(for: url)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    
    // MARK: Private functions
    
    private func performRequest(for url: URL) -> URLSession.DataTaskPublisher {
        return session.dataTaskPublisher(for: url)
    }
    
    
}



extension WebAPI {
    
    enum CombineError: Error {
        
        // MARK: Cases
        
        case released
    }
    
}
