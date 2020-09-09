//
//  ContentView.swift
//  Catfish
//
//  Created by Yak Fishman on 8/12/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//

import SwiftUI
import UIKit
struct RestaurantSearch {
    var categories: [Category]
    var price: Int
    var isOpen: Bool = true
    var hideDisliked: Bool = true
    var hideVisited: Bool = false
    var onlyWatchlist: Bool = false
    var transactions: [String]
    var distance: Double
    var rating: Int
    init() {
        self.categories = [Category(alias: "anything")]
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
    @State var sheetView: String = "detail"
    @State private var showSheet = false
    init(_ restaurantSearch: RestaurantSearch) {
        self.restaurantFetcher = (RestaurantAPI(restaurantSearch: restaurantSearch))
        
    }
    
    var restaurants: [Restaurant] {
        return self.filter(restaurantFetcher.restaurants)
        
    }
    @State private var index = 0
    @State private var photoIndex = 0
    var current: Restaurant { if(index>=restaurants.count) {return Restaurant(id: "null")} else {return restaurants[index]}}
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.showSheet = true
                    self.sheetView = "possible"
                }) {
                    Image(systemName: "eyeglasses")
                }
                Spacer()
                Button(action: {
                    self.showSheet = true
                    self.sheetView = "visited"
                }) {
                    Image(systemName: "person")
                }
                Spacer()
            }.padding(.horizontal)
                .offset(y: -45)
            if(restaurantFetcher.loading == true) {
                Spacer()
                ActivityIndicator(isAnimating: .constant(true), style: .large)
                Spacer()
            }
            else if(!restaurants.isEmpty && index<restaurants.count) {
                
                VStack {
                    Spacer()
                    VStack {
                        Text(current.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        HStack(spacing: 20) {
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
                    GeometryReader { geometry in
                        
                        PhotosView(restaurant: self.current, index: self.photoIndex)
                            .gesture(DragGesture(minimumDistance: 0.0, coordinateSpace: .local).onEnded { value in
                                if (abs(value.translation.width)+abs(value.translation.height)) < 100.0 {
                                    if(value.startLocation.x >= geometry.size.width/2) {//right half
                                        self.photoIndex += 1
                                    } else {
                                        self.photoIndex -= 1
                                    }
                                } else {
                                    if value.translation.height < 0 && value.translation.width < 100 && value.translation.width > -100 {//UP
                                        self.showSheet = true
                                        self.sheetView = "detail"
                                    } else if (value.translation.width < 0 && value.translation.height > -30 && value.translation.height < 30) {//RIGHT
                                        self.userData.possibles.append(self.current)
                                        self.index += 1
                                        self.photoIndex = 0
                                    } else if (value.translation.width > 0 && value.translation.height > -30 && value.translation.height < 30) {//Left
                                        self.index += 1
                                        self.photoIndex = 0
                                    }
                                }
                            })}
                    HStack {
                        ForEach(current.transactions, id: \.self) { cat in
                            Text(cat.capitalized)
                                .font(.callout)
                                .italic()
                        }
                    }.padding()
                    
                    ButtonsView(current: self.current)
                        .environmentObject(self.userData)
                        .padding(.horizontal).font(.largeTitle)
                    Spacer()
                    HStack(spacing: 20) {
                        VStack {
                            StarView(rating: current.rating).padding(.top).padding(.top)
                            Text("Based on \(current.review_count) Reviews").font(.subheadline).fixedSize()
                        }.foregroundColor(Color.gray)
                            .font(.largeTitle)
                        Button(action: {
                            guard let url = URL(string: self.current.url) else { return }
                            UIApplication.shared.open(url)
                        }) {
                            Image("yelp_logo").resizable().scaledToFit().frame(height: 40)
                        }.buttonStyle(PlainButtonStyle())
                    }
                    
                }
            } else {
                Spacer()
                EmptyRestaurantView()
                Spacer()
            }
        }
            //.offset(y: -80)
            .sheet(isPresented: $showSheet) {
                if(self.sheetView=="detail") {
                    DetailedView(self.current, isPresented: self.$showSheet).environmentObject(self.userData)
                } else if (self.sheetView=="visited") {
                    ProfileView(isPresented: self.$showSheet).environmentObject(self.userData)
                } else if (self.sheetView=="possible") {
                    ListView(title: "Possible", isPresented: self.$showSheet).environmentObject(self.userData)
                }
        }
    }
    
    func filter(_ results: [Restaurant]) -> [Restaurant] {
        var end = results.filter { $0.rating >= Double(restaurantFetcher.restaurantSearch.rating) }
        if(restaurantFetcher.restaurantSearch.transactions.contains("delivery")) {
            end = end.filter {
                $0.transactions.contains("delivery")
            }
        }
        if(restaurantFetcher.restaurantSearch.transactions.contains("pickup")) {
            end = end.filter {
                $0.transactions.contains("pickup")
            }
        }
        if(restaurantFetcher.restaurantSearch.hideDisliked) {
            end = end.filter {
                !self.userData.dislikes.contains($0)
            }
        }
        if(restaurantFetcher.restaurantSearch.hideVisited) {
            end = end.filter {
                !self.userData.visited.contains($0)
            }
        }
        if(restaurantFetcher.restaurantSearch.onlyWatchlist) {
            end = end.filter {
                self.userData.watchlist.contains($0)
            }
        }
        return end
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeView(RestaurantSearch(categories: [Category(alias: "anything")], price: 4, transactions: ["delivery","pickup"], distance: 5.0, rating: 3))
    }
}

struct ActivityIndicator: UIViewRepresentable {
    
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
