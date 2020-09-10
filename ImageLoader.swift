//
//  ImageLoader.swift
//  Catfish
//
//  Created by Yak Fishman on 8/30/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//

import SwiftUI
import Combine
import Foundation

class ImageLoader: ObservableObject {
    @Published var dataIsValid = false
    @Published var image:UIImage?
    var urlString: String
    var imageCache = ImageCache.getImageCache()
    
    init(urlString:String) {
        self.urlString = urlString
        loadImage()
    }
    func loadImage() {
        if loadImageFromCache() {
            return
        }
        loadImageFromURL()
    }
    
    func loadImageFromURL() {
        guard let url = URL(string: self.urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                let loadedImage = UIImage(data: data)
               // self.imageCache.set(forKey: self.urlString, image: loadedImage!)
                self.dataIsValid = true
                self.image = loadedImage!
                
            }
        }
        task.resume()
    }
    
    func loadImageFromCache() -> Bool {
        
        
        guard let cacheImage = imageCache.get(forKey: self.urlString) else {
            return false
        }
        self.image = cacheImage
        return true
    }
    
}
