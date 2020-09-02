//
//  MoneySlider.swift
//  Catfish
//
//  Created by Yak Fishman on 8/14/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//

import SwiftUI

struct MoneySlider: View {
    @Binding var rating: Int

    var label = ""

    var maximumRating = 5

    var offImage: Image?
    var onImage = Image(systemName: "dollarsign.circle.fill")

    var offColor = Color.gray
    var onColor = Color.yellow
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
    var body: some View {
        HStack {
            if label.isEmpty == false {
                Text(label)
            }

            ForEach(1..<maximumRating + 1) { number in
                self.image(for: number)
                    .foregroundColor(number > self.rating ? self.offColor : self.onColor)
                    .onTapGesture {
                        self.rating = number
                    }
            }
        }
    }
    
}
