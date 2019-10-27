//
//  WebAPI.Endpoint.swift
//  Picnic Giphy
//
//  Created by Amir on 27/10/2019.
//  Copyright © 2019 Amir. All rights reserved.
//

import Foundation

extension WebAPI {
    
    enum Endpoint {
        case trending(Int, Int)
        case random
        
        private var path: String {
            switch self {
            case .random:
                return "random"
            case let .trending(limit, offset):
                return "trending?offset=\(offset)&limit=\(limit)"
            }
        }
        
        func asURL(apiKey: String) throws -> URL {
            var urlComponents = URLComponents()
            let basePath = "/v1/gifs/"
            urlComponents.scheme = "https"
            urlComponents.host = "api.giphy.com"
            urlComponents.path = "\(basePath)\(path.components(separatedBy: "?").first!)"
            urlComponents.query = path.components(separatedBy: "?").last ?? ""
            urlComponents.query?.append(contentsOf: "&api_key=\(apiKey)")
            
            guard let url = urlComponents.url else {
                throw URLError(.badURL)
            }
            return url
        }
        
    }
    
}
