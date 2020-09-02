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
    var photos: [String] { detailedFetcher.photos}
    var hours: [Hours] { detailedFetcher.hours}
    init(_ restaurant: Restaurant,isPresented: Binding<Bool>) {
        self.detailedFetcher = DetailedAPI(id: restaurant.id)
        self.restaurant = restaurant
        self.isPresented = isPresented
    }
    var body: some View {
        NavigationView {
        VStack {
//            if(!photos.isEmpty) {
//                ImageView(withURL: photos[1])
//                    //.resizable()
//                    .edgesIgnoringSafeArea(.top)
//                    .frame(height: 300)
//            }
            MapView(coordinate: CLLocationCoordinate2D(latitude: restaurant.coordinates.latitude, longitude: restaurant.coordinates.longitude),name: restaurant.name)
                .edgesIgnoringSafeArea(.horizontal)
            .frame(height: 450)
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
                
                    
//                    .clipShape(Circle())
//                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
//                    .shadow(radius: 10)
//                    .offset(x: 0, y: -70)
//                    .padding(.bottom, -70)
//                    .frame(height: 150)
            
            Text(restaurant.name)
                .font(.title).padding()
            
            
            if(!hours.isEmpty) {
                HoursView(hours: hours[0].open)
                
            }
            
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
                    NavigationLink(
                        destination: ReviewsView(self.restaurant,isPresented: self.isPresented))
                    {
                        Text("See Reviews")
                    }
                
            }.padding()
            
        }.sheet(isPresented: $isShareShowing) {
            ShareSheet(activityItems: [self.restaurant.url])
        }
        }
    }
}

//struct DetailedView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailedView(isPresented: true)
//    }
//}
