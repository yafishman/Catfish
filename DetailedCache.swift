//
//  DetailedCache.swift
//  Catfish
//
//  Created by Yak Fishman on 9/10/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//
import Foundation
import SwiftUI

class DetailedCache {
    var cache = NSCache<NSString, DetailedAPI>()
    
    func get(forKey: String) -> DetailedAPI? {
        return cache.object(forKey: NSString(string: forKey))
    }
    
    func set(forKey: String, image: DetailedAPI) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
}

extension DetailedCache {
    private static var detailedCache = DetailedCache()
    static func getDetailedCache() -> DetailedCache {
        return detailedCache
    }
}
