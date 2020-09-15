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
            VStack(alignment: .leading) {
            Text(restaurant.name).bold()
            Text("\(restaurant.location.city), \(restaurant.location.state)").font(.footnote)
            }
            Spacer()
            
            if isLiked {
                Image(systemName: "hand.thumbsup.fill")
                    .imageScale(.medium)
                    .foregroundColor(.green)
            } else if isDisliked {
                Image(systemName: "hand.thumbsdown.fill")
                    .imageScale(.medium)
                    .foregroundColor(.red)
            } else if isWatched {
                Image(systemName: "bookmark.fill")
                    .imageScale(.medium)
                    .foregroundColor(.orange)
            }
        }
    }
}


