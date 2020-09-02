//
//  ReviewRowView.swift
//  Catfish
//
//  Created by Yak Fishman on 9/2/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//

import SwiftUI

struct ReviewRowView: View {
    var review: Review
    var body: some View {
        VStack {
            HStack {
                Text("\(review.user.name) on \(review.time_created)")
                Spacer()
                StarView(rating: Double(review.rating))
            }
            Text(review.text)
        }
        
    }
}
