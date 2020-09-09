//
//  DetailedView.swift
//  Catfish
//
//  Created by Yak Fishman on 8/14/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//

import SwiftUI
import UIKit
import MapKit

struct DetailedView: View {
    
    @State private var isShareShowing: Bool = false
    var restaurant: Restaurant
    var isPresented: Binding<Bool>
    @ObservedObject var detailedFetcher: DetailedAPI
    @EnvironmentObject var userData: UserData
    var photos: [String] { detailedFetcher.photos}
    var hours: [Hours] { detailedFetcher.hours}
    init(_ restaurant: Restaurant,isPresented: Binding<Bool>) {
        self.detailedFetcher = DetailedAPI(id: restaurant.id)
        self.restaurant = restaurant
        self.isPresented = isPresented
    }
    var body: some View {
        VStack {
            MapView(coordinate: CLLocationCoordinate2D(latitude: restaurant.coordinates.latitude, longitude: restaurant.coordinates.longitude),name: restaurant.name).frame(height: 400)
            Button(action: {
                let formattedString = "http://maps.apple.com/?daddr=\(self.restaurant.name)&dirflg=d&t=m"
                guard let url = URL(string: formattedString) else { return }
                UIApplication.shared.open(url)
            }) {
                VStack {
                    Text(restaurant.location.display_address[0])
                    Text(restaurant.location.display_address[1])
                }
            }.padding().font(.subheadline)
                .font(.subheadline)
            
            Text(restaurant.name)
                .font(.title).padding()
            
            
            if(!hours.isEmpty) {
                HoursView(hours: hours[0].open)
                
            }
            ButtonsView(current: self.restaurant).environmentObject(self.userData)
                .padding().font(.title)
            HStack {
                Button(action: {
                    let tel = "tel://\(self.restaurant.phone)"
                    guard let url = URL(string: tel) else { return }
                    UIApplication.shared.open(url)
                }) {
                    Text(restaurant.display_phone)
                }
                Spacer()
                Button(action: {
                    self.isShareShowing.toggle()
                }) {
                    Image(systemName: "square.and.arrow.up").font(.title)
                }
                Spacer()
                //                    NavigationLink(
                //                        destination: ReviewsView(self.restaurant,isPresented: self.isPresented))
                //                    {
                //                        Text("See Reviews")
                //                    }
                Button(action: {
                    guard let url = URL(string: self.restaurant.url) else { return }
                    UIApplication.shared.open(url)
                }) {
                    Image("yelp_logo").resizable().scaledToFit().frame(height: 40)
                }.buttonStyle(PlainButtonStyle())
                
            }.padding()
            
        }.edgesIgnoringSafeArea(.all)
            .sheet(isPresented: $isShareShowing) {
                ShareSheet(activityItems: [self.restaurant.url])
        }
        
    }
}


