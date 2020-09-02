//
//  RestaurantRow.swift
//  Catfish
//
//  Created by Yak Fishman on 9/2/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//

import SwiftUI

struct RestaurantRow: View {
    var restaurant: Restaurant
    var isLiked: Bool
    var isDisliked: Bool
    var isWatched: Bool

    var body: some View {
        HStack {
            ImageView(withURL: restaurant.image_url)
                .frame(width: 50, height: 50)
            Text(restaurant.name)
            Spacer()

            if isLiked {
                Image(systemName: "heart.fill")
                    .imageScale(.medium)
                    .foregroundColor(.red)
            } else if isDisliked {
                Image(systemName: "hand.thumbsdown")
                .imageScale(.medium)
                .foregroundColor(.black)
            } else if isWatched {
                Image(systemName: "eye")
                .imageScale(.medium)
                .foregroundColor(.blue)
            }
        }
    }
}


