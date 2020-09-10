//
//  ImageView.swift
//  Catfish
//
//  Created by Yak Fishman on 8/30/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//

import SwiftUI

struct ImageView: View {
    @ObservedObject var imageLoader:ImageLoader
    
    init(withURL url:String) {
        imageLoader = ImageLoader(urlString:url)
    }
    
    func imageFromData(_ data:Data) -> UIImage {
        UIImage(data: data) ?? UIImage()
    }
    
    var body: some View{
        Image(uiImage: imageLoader.dataIsValid ? imageLoader.image! : UIImage())
            .resizable()
            .opacity(0.85)
            .aspectRatio(contentMode: .fit)
    }
}
