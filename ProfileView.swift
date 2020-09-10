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
    @State var buttons: Bool = false
    @State var filter: Int = 0
    @State var searchText: String = ""
    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: $filter,label: Text("Filter")) {
                    Text("Visited").tag(0)
                    Text("Liked").tag(1)
                    Text("Watchlisted").tag(2)
                    Text("Disliked").tag(3)
                }.pickerStyle(SegmentedPickerStyle())
                SearchBar(text: $searchText)
                List {
                    if (self.filter == 1) {
                        display(restaurants: userData.likes.filter({ searchText.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(searchText) }))
                    } else if (self.filter == 2) {
                        display(restaurants: userData.watchlist.filter({ searchText.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(searchText) }))
                    } else if (self.filter == 3) {
                        display(restaurants: userData.dislikes.filter({ searchText.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(searchText) }))
                    } else {
                        display(restaurants: userData.visited.filter({ searchText.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(searchText) })).zIndex(10)
                    }
                    
                }.navigationBarTitle(Text("Visited Restaurants"))
                
            }.blur(radius: self.buttons ? 10 : 0)

        }
    }
    func display(restaurants: [Restaurant]) -> some View {
        
        return  ForEach(restaurants, id: \.self) { restaurant in
            NavigationLink(
                destination: DetailedView(restaurant, isPresented: self.$isPresented)
            ) {
                RestaurantRow(restaurant: restaurant, isLiked: self.userData.likes.contains(where: {$0.id==restaurant.id}),
                              isDisliked: self.userData.dislikes.contains(where: {$0.id==restaurant.id}),
                              isWatched: self.userData.watchlist.contains(where: {$0.id==restaurant.id}))
                
                
                
            }
            //.sheet(isPresented: self.$buttons) {
            
            // }
//                        .highPriorityGesture(LongPressGesture()
//                        .onEnded { _ in
//                            self.buttons.toggle()
//                        })
            
        }
        
        
        
    }
    
}

