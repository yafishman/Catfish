//
//  ImageCache.swift
//  Catfish
//
//  Created by Yak Fishman on 9/9/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//

import Foundation
import SwiftUI

class ImageCache {
    var cache = NSCache<NSString, UIImage>()
    
    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }
    
    func set(forKey: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
}

extension ImageCache {
    private static var imageCache = ImageCache()
    static func getImageCache() -> ImageCache {
        return imageCache
    }
}
