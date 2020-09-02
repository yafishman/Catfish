//
//  ProfileView.swift
//  Catfish
//
//  Created by Yak Fishman on 8/17/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var userData: UserData
    @Binding var isPresented: Bool
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(userData.profile.possibles, id: \.self) { restaurant in
                                NavigationLink(
                                    destination: DetailedView(restaurant, isPresented: self.$isPresented)
                                ) {
                                    RestaurantRow(restaurant: restaurant, isLiked: self.userData.profile.likes.contains(restaurant),
                                                  isDisliked: self.userData.profile.dislikes.contains(restaurant),
                                                  isWatched: self.userData.profile.watchlist.contains(restaurant))
                                }
                    }
                    
                }.navigationBarTitle(Text("Possible Restaurants"))
                HStack(spacing: 50) {
                    NavigationLink(
                        destination: ListView(restaurants: userData.profile.dislikes, title: "Disliked", isPresented: self.$isPresented)
                    ) {
                        Text("Disliked")
                    }
                    NavigationLink(
                        destination: ListView(restaurants: userData.profile.watchlist, title: "Watchlisted", isPresented: self.$isPresented)
                    ) {
                        Text("Watchlist")
                    }
                    NavigationLink(
                        destination: ListView(restaurants: userData.profile.likes, title: "Liked", isPresented: self.$isPresented)
                    ) {
                        Text("Liked")
                    }
                }
            }
        }
    }
}

