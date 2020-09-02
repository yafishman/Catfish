//
//  PhotosView.swift
//  Catfish
//
//  Created by Yak Fishman on 9/2/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//
import SwiftUI


struct PhotosView: View {

    var photo: String
    var index: Int
    var maxIndex: Int

    init(photo: String, index: Int, maxIndex: Int) {
        self.photo = photo
        self.index = index
        self.maxIndex = maxIndex
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { geometry in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ImageView(withURL: self.photo)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
        
                    }
                }
                .frame(width: geometry.size.width, alignment: .leading)
                        //                    including: DragGesture(minimumDistance: 0)
//                    .onEnded { value in
//                        let num = value.startLocation.x
//                        if(num >= geometry.size.width/2) {//right half
//                            self.index = self.clampedIndex(predictedIndex: self.index+1)
//                        } else {
//                            self.index = self.clampedIndex(predictedIndex: self.index-1)
//                        }
//                    }
            }
            .clipped()

            PageControl(index: self.index, maxIndex: self.maxIndex)
        }
    }

    func clampedIndex(predictedIndex: Int) -> Int {
        if(predictedIndex == -1) {
            return maxIndex-1
        } else if (predictedIndex == maxIndex) {
            return 0
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

