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
    @State var searchText: String = ""
    init(restaurantSearch: Binding<RestaurantSearch>, isPresented: Binding<Bool>) {
        _restaurantSearch = restaurantSearch
        _isPresented = isPresented
        _draft = State(wrappedValue: restaurantSearch.wrappedValue)
        _deliv = State(wrappedValue: restaurantSearch.wrappedValue.transactions.contains("delivery"))
        _pickup = State(wrappedValue: restaurantSearch.wrappedValue.transactions.contains("pickup"))
        setup()
    }
    func setup() {
 
    }
    var body: some View {
        NavigationView {
            Form {
//                VStack {
//                    Text("Location")
//                    FilterSearchBar(text: $searchText)
//                }
                
                HStack {
                    Text("Max Price")
                    Spacer()
                    MoneySlider(rating: $draft.price)
                }
                VStack {
                    HStack {
                        Text("0.2 mi")
                        Slider(value: $draft.distance, in: 0.2...25, step: 0.1)
                        Text("25 mi")
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
                        self.draft.isOpen.toggle()
                    
                }) {
                    HStack {
                        Text("Open Now").foregroundColor(self.draft.isOpen ? .blue: .black)
                        Spacer()
                        if self.draft.isOpen {
                            Image(systemName: "checkmark")
                        }
                    }
                    
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
                        Text("Delivery").foregroundColor(self.deliv ? .blue: .black)
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
                        Text("Pickup").foregroundColor(self.pickup ? .blue: .black)
                        Spacer()
                        if self.pickup {
                            Image(systemName: "checkmark")
                        }
                    }
                    
                }
                
                Button(action: {
                        self.draft.hideDisliked.toggle()
                    
                }) {
                    HStack {
                        Text("Hide Disliked").foregroundColor(self.draft.hideDisliked ? .blue: .black)
                        Spacer()
                        if self.draft.hideDisliked {
                            Image(systemName: "checkmark")
                        }
                    }
                    
                }
                Button(action: {
                        self.draft.hideVisited.toggle()
                    
                }) {
                    HStack {
                        Text("Hide Visited").foregroundColor(self.draft.hideVisited ? .blue: .black)
                        Spacer()
                        if self.draft.hideVisited {
                            Image(systemName: "checkmark")
                        }
                    }
                    
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

