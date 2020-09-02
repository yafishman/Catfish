//
//  ContentView.swift
//  Catfish
//
//  Created by Yak Fishman on 8/12/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//

import SwiftUI
struct RestaurantSearch {
    var categories: [Category]
    var price: Int
    var isOpen: Bool = true
    var transactions: [String]
    var distance: Double
    var rating: Int
    init() {
        self.categories = [Category(alias: "anything", title: "Anything")]
        self.price = 5
        self.transactions = []
        self.distance = 5.0
        self.rating = 1
    }
    init(categories: [Category], price: Int, transactions: [String], distance: Double, rating: Int) {
        self.categories = categories
        self.price = price
        self.transactions = transactions
        self.distance = distance
        self.rating = rating
    }
}

struct SwipeView: View {
    @EnvironmentObject var userData: UserData
    @ObservedObject var restaurantFetcher: RestaurantAPI
    @State var restaurantSearch = RestaurantSearch()
    @State var sheetView: String = "detail"
    @State private var showSheet = false
    init(_ restaurantSearch: RestaurantSearch) {
        self.restaurantFetcher = RestaurantAPI(restaurantSearch: restaurantSearch)
        
    }
    
    var restaurants: [Restaurant] { restaurantFetcher.restaurants}
    @State private var index = 0
    var current: Restaurant { restaurants[index]}
    
    var body: some View {
        VStack {
            if(!restaurants.isEmpty || index<restaurants.count) {
                HStack {
                    Button(action: {
                        self.showSheet = true
                        self.sheetView = "profile"
                    }) {
                        Image(systemName: "person")
                    }
                    
                    
                    Spacer()
                    Button("Filter") {
                        self.showSheet = true
                        self.sheetView = "filter"
                    }
                    
                }.padding(.horizontal)
                Spacer()
                VStack {
                    Text(current.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    HStack {
                        ForEach(current.categories, id: \.self) { cat in
                            Text(cat.title.capitalized)
                                .font(.callout)
                                .italic()
                        }
                    }
                    PriceView(price: current.price).font(.title)
                    Text("\(current.distanceMiles, specifier: "%.2f") mi away").font(.callout).italic()
                }
                .foregroundColor(Color.black)
                ImageView(withURL: current.image_url)
                HStack {
                    ForEach(current.transactions, id: \.self) { cat in
                        Text(cat.capitalized)
                            .font(.callout)
                            .italic()
                    }
                }
                Spacer()
                HStack(spacing: 50) {
                    Button(action: {
                        self.userData.profile.dislikes.append(self.current)
                        self.userData.profile.watchlist.removeAll {$0.id==self.current.id}
                        self.userData.profile.likes.removeAll {$0.id==self.current.id}
                    }) {
                        if self.userData.profile.dislikes.contains(self.current) {
                            Image(systemName: "hand.thumbsdown.fill")
                        } else {
                            Image(systemName: "hand.thumbsdown")
                        }
                        
                    }
                    Button(action: {
                        self.userData.profile.watchlist.append(self.current)
                        self.userData.profile.dislikes.removeAll {$0.id==self.current.id}
                        self.userData.profile.likes.removeAll {$0.id==self.current.id}
                    }) {
                        if self.userData.profile.watchlist.contains(self.current) {
                            Image(systemName: "bookmark.fill")
                        } else {
                            Image(systemName: "bookmark")
                        }
                    }
                    Button(action: {
                        self.userData.profile.likes.append(self.current)
                        self.userData.profile.watchlist.removeAll {$0.id==self.current.id}
                        self.userData.profile.dislikes.removeAll {$0.id==self.current.id}
                    }) {
                        if self.userData.profile.likes.contains(self.current) {
                            Image(systemName: "hand.thumbsup.fill")
                        } else {
                            Image(systemName: "hand.thumbsup")
                        }
                    }
                }.padding(.horizontal).font(.largeTitle)
                Spacer()
                VStack {
                    StarView(rating: current.rating).padding(.top).padding(.top)
                    Text("\(current.review_count) Reviews").font(.subheadline)
                }.foregroundColor(Color.yellow)
                    .font(.largeTitle)
                    .cornerRadius(15.0)
            }
        }
        .gesture(DragGesture(minimumDistance: 100.0, coordinateSpace: .local).onEnded { value in
            if value.translation.height < 0 && value.translation.width < 100 && value.translation.width > -100 {//UP
                self.showSheet = true
                self.sheetView = "detail"
            } else if (value.translation.width < 0 && value.translation.height > -30 && value.translation.height < 30) {//RIGHT
                self.userData.profile.possibles.append(self.current)
                self.index += 1
            }
        }).sheet(isPresented: $showSheet) {
            if(self.sheetView=="detail") {
                DetailedView(self.current, isPresented: self.$showSheet)
            }else if (self.sheetView=="filter") {
                FilterRestaurants(restaurantSearch: self.$restaurantSearch, isPresented: self.$showSheet)
            } else if (self.sheetView=="profile") {
                ProfileView(isPresented: self.$showSheet).environmentObject(self.userData)
            }
            
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeView(RestaurantSearch(categories: [Category(alias: "anything", title: "Anything")], price: 4, transactions: ["delivery","pickup"], distance: 5.0, rating: 3))
    }
}
