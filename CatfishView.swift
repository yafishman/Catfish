//
//  CatfishView.swift
//  Catfish
//
//  Created by Yak Fishman on 9/7/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//

import SwiftUI

struct CatfishView: View {
    @State var restaurantSearch = RestaurantSearch()
    @State private var showSheet = false
    var body: some View {
        VStack(alignment: .trailing) {
            Button("Filter") {
                self.showSheet = true
            }.sheet(isPresented: $showSheet) {
                FilterRestaurants(restaurantSearch: self.$restaurantSearch, isPresented: self.$showSheet)
            }.padding()
            SwipeView(restaurantSearch)
        }.background(Rectangle().fill(Color.gray).opacity(0.1).edgesIgnoringSafeArea(.all))

        
        
        
    }
    var filter: some View {
        Button("Filter") {
            self.showSheet = true
        }.sheet(isPresented: $showSheet) {
            FilterRestaurants(restaurantSearch: self.$restaurantSearch, isPresented: self.$showSheet)
        }
    }
}

