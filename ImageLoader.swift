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
    var data:Data?
    
    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.dataIsValid = true
                self.data = data
            }
        }
        task.resume()
    }
}
