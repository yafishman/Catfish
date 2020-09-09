//
//  FilterRestaurants.swift
//  Catfish
//
//  Created by Yak Fishman on 8/12/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//


import SwiftUI

struct FilterRestaurants: View {
    
    @Binding var restaurantSearch: RestaurantSearch
    @Binding var isPresented: Bool
    
    @State private var draft: RestaurantSearch
    @State var percentage: Float = 50
    @State var deliv: Bool
    @State var pickup: Bool
    
    init(restaurantSearch: Binding<RestaurantSearch>, isPresented: Binding<Bool>) {
        _restaurantSearch = restaurantSearch
        _isPresented = isPresented
        _draft = State(wrappedValue: restaurantSearch.wrappedValue)
        _deliv = State(wrappedValue: restaurantSearch.wrappedValue.transactions.contains("delivery"))
        _pickup = State(wrappedValue: restaurantSearch.wrappedValue.transactions.contains("pickup"))
    }
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Text("Max Price")
                    Spacer()
                    MoneySlider(rating: $draft.price)
                }
                VStack {
                    HStack {
                        Text("0.5 mi")
                        Slider(value: $draft.distance, in: 0.5...30, step: 0.5)
                        Text("30 mi")
                    }
                    Text("\(String(format: "%.1f", draft.distance)) mi away")
                }
                
                HStack {
                    Text("Min Rating")
                    Spacer()
                    StarSlider(rating: $draft.rating)
                }
                
                NavigationLink(destination: PickerView(selections: self.$draft.categories)) {
                    CategoryLabelView(categories: self.$draft.categories)
                }
                Button(action: {
                    if(self.deliv) {
                        self.draft.transactions.remove(at: self.draft.transactions.firstIndex(of: "delivery")!)
                    } else {
                        self.draft.transactions.append("delivery")
                    }
                    
                    self.deliv.toggle()
                    
                }) {
                    HStack {
                        Text("Delivery")
                        Spacer()
                        if self.deliv {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                Button(action: {
                    if(self.pickup) {
                        self.draft.transactions.remove(at: self.draft.transactions.firstIndex(of: "pickup")!)
                    } else {
                        self.draft.transactions.append("pickup")
                    }
                    
                    self.pickup.toggle()
                }) {
                    HStack {
                        Text("Pickup")
                        Spacer()
                        if self.pickup {
                            Image(systemName: "checkmark")
                        }
                    }
                    
                }
                HStack {
                    Toggle(isOn: $draft.isOpen) { Text("Open now") }
                    Toggle(isOn: $draft.onlyWatchlist) { Text("Only watchlist") }
                }
                HStack {
                    Toggle(isOn: $draft.hideDisliked) { Text("Hide disliked") }
                    Toggle(isOn: $draft.hideVisited) { Text("Hide visited") }
                    
                }
                
                
            }
            .navigationBarTitle("Filter Restaurants")
            .navigationBarItems(leading: cancel, trailing: done)
        }
    }
    
    var cancel: some View {
        Button("Cancel") {
            self.isPresented = false
        }
    }
    var done: some View {
        Button("Done") {
            self.restaurantSearch = self.draft
            self.isPresented = false
        }
    }
}
struct CategoryLabelView: View {
    @Binding var categories: [Category]
    var anything = Category(alias: "anything")
    var body: some View {
        HStack {
            Text("Categories")
            Spacer()
            if(categories.contains(anything) || categories.count==0) {
                Text("Anything").opacity(0.5)
            } else if(categories.count==1) {
                Text(categories[0].title).opacity(0.5)
            } else {
                Text("\(categories[0].title) & ……").opacity(0.5)
            }
        }
        
    }
}

