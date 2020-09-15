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
    var hideDisliked: Bool = false
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
    @State private var offset: CGSize = CGSize.zero
    @State private var animation: Animation = Animation.default
    @State private var animate: Bool = false
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
    @State private var rightSwipe: Bool = false
    @State private var leftSwipe: Bool = false
    var cache = DetailedCache.getDetailedCache()
    var current: Restaurant { if(index>=restaurants.count) {return Restaurant(id: "null")} else {return restaurants[index]}}
    var detailedFetcher: DetailedAPI {
        if let cachedVersion = cache.get(forKey: self.current.id) {
            return cachedVersion
        } else {
            cache.set(forKey: current.id, image: DetailedAPI(id: current.id))
            return DetailedAPI(id: current.id)
        }
        
        
    }
    
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
                GeometryReader { geometry in
                    
                    VStack {
                        Spacer()
                        VStack {
                            Text(self.current.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            HStack(spacing: 20) {
                                ForEach(self.current.categories, id: \.self) { cat in
                                    Text(cat.title.capitalized)
                                        .font(.callout)
                                        .italic()
                                }
                            }
                            PriceView(price: self.current.price).font(.title)
                            Text("\(self.current.distanceMiles, specifier: "%.2f") mi away").font(.callout).italic()
                            Text(self.current.is_closed ? "Closed" : "Open Now").foregroundColor(self.current.is_closed ? .red : .green)
                        }
                        
                        //PhotosView(restaurant: self.current, index: self.photoIndex)
                        ZStack {
                            
                        PhotosView(restaurant: self.current, detailed: self.detailedFetcher, index: self.photoIndex)
                            .gesture(DragGesture(minimumDistance: 0.0, coordinateSpace: .local)
                                .onChanged({ value in
                                    if (abs(value.translation.width)+abs(value.translation.height)) < 100.0 {
                                    } else {
                                        //self.offset.width = value.translation.width - geometry.size.width * CGFloat(self.index)
                                        if (value.translation.width > 0 && value.translation.height > -30 && value.translation.height < 30) {//RIGHT
                                            self.rightSwipe=true
                                        } else if (value.translation.width < 0 && value.translation.height > -30 && value.translation.height < 30) {
                                            self.leftSwipe=true
                                        }
                                        self.offset = value.translation
                                    }
                                    })
                                    .onEnded { value in
                                        if (abs(value.translation.width)+abs(value.translation.height)) < 100.0 {
                                            if(value.startLocation.x >= geometry.size.width/2) {//right half
                                                self.photoIndex += 1
                                                self.animation = Animation.easeInOut
                                                self.animate = false
                                                
                                            } else {
                                                self.photoIndex -= 1
                                                self.animation = Animation.easeInOut
                                                self.animate = false
                                            }
                                        } else {
                                            withAnimation {
                                                if value.translation.height < 0 && value.translation.width < 100 && value.translation.width > -100 {//UP
                                                    self.showSheet = true
                                                    self.sheetView = "detail"
                                                    self.animate = false
                                                } else if (value.translation.width > 0 && value.translation.height > -30 && value.translation.height < 30) {//RIGHT
                                                    self.userData.possibles.append(self.current)
                                                    self.index += 1
                                                    self.photoIndex = 0
                                                    self.animation = Animation.interactiveSpring()
                                                    self.animate = true
                                                } else if (value.translation.width < 0 && value.translation.height > -30 && value.translation.height < 30) {//Left
                                                    self.index += 1
                                                    self.photoIndex = 0
                                                    self.animation = Animation.interactiveSpring()
                                                    self.animate = true
                                                }
                                            }
                                        }
                                        
                                        self.offset = CGSize.zero
                                        self.rightSwipe=false
                                        self.leftSwipe=false
                                    })
                            if(self.rightSwipe) {
                                Text("YUP!").foregroundColor(.green).bold().font(.largeTitle).padding()
                                .border(Color.green, width: 10).offset(x: -100, y: -150)
                            } else if (self.leftSwipe) {
                                Text("NOPE").foregroundColor(.red).bold().font(.largeTitle).padding()
                                    .border(Color.red, width: 10).offset(x: 100, y: -150)
                            }
                    }
                                    
                                    //.animation(self.animation)
                                    //.animation(self.animate ? .interactiveSpring() : .none)
                                    HStack {
                                        ForEach(self.current.transactions, id: \.self) { cat in
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
                                            StarView(rating: self.current.rating).padding(.top).padding(.top)
                                            Text("Based on \(self.current.review_count) Reviews").font(.subheadline).fixedSize()
                                        }.foregroundColor(Color.gray)
                                            .font(.largeTitle)
                                        Button(action: {
                                            guard let url = URL(string: self.current.url) else { return }
                                            UIApplication.shared.open(url)
                                        }) {
                                            Image("yelp_logo").resizable().scaledToFit().frame(height: 40)
                                        }.buttonStyle(PlainButtonStyle())
                                    }
                                    
                                    }.offset(x: self.offset.width)
                                    .rotationEffect(.degrees(Double(self.offset.width / 50)))
                                    .transition(AnyTransition.slide).animation(.linear)
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
                    DetailedView(self.current, detailed: self.detailedFetcher, isPresented: self.$showSheet).environmentObject(self.userData)
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
            if(restaurantFetcher.restaurantSearch.categories.firstIndex(where: { $0.alias=="anything"
            }) == nil) {
                var belongs: Bool
                for restaurant in end {
                    belongs = false
                    for category in restaurant.categories {
                        if(restaurantFetcher.restaurantSearch.categories.contains(where: {$0.alias==category.alias})) {
                            belongs = true
                        }
                    }
                    if !belongs {
                        end.remove(at: end.firstIndex(of: restaurant)!)
                    }
                }
                
            }
            return end
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
