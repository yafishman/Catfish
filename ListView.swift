//
//  ListView.swift
//  Catfish
//
//  Created by Yak Fishman on 9/2/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//

import SwiftUI

struct ListView: View {
    var restaurants: [Restaurant]
    var title: String
    @Binding var isPresented: Bool
    var body: some View {
        NavigationView {
                List {
                    ForEach(self.restaurants, id: \.self) { restaurant in
                                NavigationLink(
                                    destination: DetailedView(restaurant, isPresented: self.$isPresented)
                                ) {
                                    RestaurantRow(restaurant: restaurant, isLiked: self.title=="Liked",
                                                  isDisliked: self.title=="Disliked",
                                                  isWatched: self.title=="Watchlisted")
                                }
                    }
                    
                }.navigationBarTitle(Text("\(title) Restaurants"))
        }
    }
}
