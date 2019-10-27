//
//  WebAPI.Giphy.swift
//  Picnic Giphy
//
//  Created by Amir on 27/10/2019.
//  Copyright © 2019 Amir. All rights reserved.
//

import Foundation

extension WebAPI {
    
    struct Giphy: Decodable {
        
        // MARK: Constants
        
        struct Images: Decodable {
            
            // MARK: Constants
            
            enum CodingKeys: String, CodingKey {
                case preview = "downsized_still"
                case original
            }
            
            struct Asset: Decodable {
                let url: String
            }
            
            
            // MARK: Properties
            
            let preview: Asset
            let original: Asset
        }
        
        
        // MARK: Properties
        
        let title: String
        let images: Images
    }
    
}
