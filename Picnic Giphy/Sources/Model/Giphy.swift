//
//  Giphy.swift
//  Picnic Giphy
//
//  Created by Amir on 26/10/2019.
//  Copyright © 2019 Amir. All rights reserved.
//

import Foundation

struct Giphy {
    
    let title: String
    let previewImageURL: URL
}


extension Giphy: Identifiable {
    var id: String {
        return previewImageURL.absoluteString
    }
}


extension Giphy: Cacheable {
    var cacheKey: String {
        return previewImageURL.absoluteString
    }
}
