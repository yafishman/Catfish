//
//  ReviewsView.swift
//  Catfish
//
//  Created by Yak Fishman on 9/2/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//

import SwiftUI

struct ReviewsView: View {
      var restaurant: Restaurant
      var isPresented: Binding<Bool>
      @ObservedObject var reviewFetcher: ReviewAPI
      var reviews: [Review] { reviewFetcher.reviews}
      init(_ restaurant: Restaurant,isPresented: Binding<Bool>) {
          self.reviewFetcher = ReviewAPI(id: restaurant.id)
          self.restaurant = restaurant
          self.isPresented = isPresented
      }
    var body: some View {
        List {
            ForEach(self.reviews, id: \.self) { review in
               ReviewRowView(review: review)
            }
            
        }.navigationBarTitle(Text("Reviews for \(self.restaurant.name)"))
    }
}
