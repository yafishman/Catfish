//
//  PhotosView.swift
//  Catfish
//
//  Created by Yak Fishman on 9/2/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//
import SwiftUI


struct PhotosView: View {
    
    var restaurant: Restaurant
    var index: Int
    
    @ObservedObject var detailedFetcher: DetailedAPI
    var photos: [String] { detailedFetcher.photos}
    var maxIndex: Int { photos.count}
//    init(restaurant: Restaurant, index: Int) {
//        self.detailedFetcher = DetailedAPI(id: restaurant.id)
//        self.restaurant = restaurant
//        self.index = index
//    }
    init(restaurant: Restaurant, detailed: DetailedAPI, index: Int) {
        self.detailedFetcher = detailed
        self.restaurant = restaurant
        self.index = index
    }
    var body: some View {
        VStack(alignment: .center) {
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    if(self.detailedFetcher.loading == true) {
                        Spacer()
                        ActivityIndicator(isAnimating: .constant(true), style: .large)
                        Spacer()
                    } else {
                        if(self.maxIndex==0) {
                            ImageView(withURL: self.restaurant.image_url)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .clipped()
                        } else {
                            ImageView(withURL: self.photos[self.clampedIndex(predictedIndex: self.index)] )
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .clipped()
                            
                        }
                    }
                    
                    
                }.shadow(radius: 12.0)
                .cornerRadius(12.0)
                .frame(width: geometry.size.width, alignment: .leading)
                
            }
            .clipped()
            
            PageControl(index: self.clampedIndex(predictedIndex: self.index), maxIndex: self.maxIndex)
        }
    }
    
    func clampedIndex(predictedIndex: Int) -> Int {
        if(self.maxIndex == 0) {
            return 0
        } else if(predictedIndex < 0) {
            return predictedIndex * (-1) % maxIndex
        } else if (predictedIndex >= maxIndex) {
            return predictedIndex%maxIndex
        } else {
            return predictedIndex
        }
    }
}

struct PageControl: View {
    var index: Int
    let maxIndex: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<maxIndex, id: \.self) { index in
                Circle()
                    .fill(index == self.index ? Color.gray : Color.black)
                    .frame(width: 8, height: 8)
            }
        }
        
    }
}

