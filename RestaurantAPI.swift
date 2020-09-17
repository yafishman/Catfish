//
//  RestaurantAPI.swift
//  Catfish
//
//  Created by Yak Fishman on 8/12/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//

import Foundation
import SwiftUI
import CoreLocation

class RestaurantAPI: ObservableObject {
    @Published private(set) var restaurants = [Restaurant]()
    @ObservedObject var lm = LocationManager()
    @Published var loading = false
    var latitude: String  { return("\(lm.location?.latitude ?? 0)") }
    var longitude: String { return("\(lm.location?.longitude ?? 0)") }
    //var status: String    { return("\(lm.status)") }
    
    init(restaurantSearch: RestaurantSearch) {
        self.restaurantSearch = restaurantSearch
        fetchYelpBusinesses()
    }
    
    var restaurantSearch: RestaurantSearch {
        didSet { fetchYelpBusinesses() }
    }
    private func fetchYelpBusinesses(){
               // let geocoder = CLGeocoder()
                    
                // Look up the location and pass it to the completion handler
       // if( !(self.lm.location==nil)) {
//            //let newLoc = CLLocation(latitude: lm.location?.latitude ?? 0, longitude: lm.location?.longitude ?? 0)
//        let newLoc = CLLocation(latitude: 38.654154, longitude: -90.307697)
//        geocoder.reverseGeocodeLocation(newLoc,
//                            completionHandler: { (placemarks, error) in
//                    if error == nil {
//                       // let firstLocation = placemarks?[0]
//                        //print(placemarks)
//                        //completionHandler(firstLocation)
//
//                    }
//                    else {
//                     // An error occurred during geocoding.
//                        //completionHandler(nil)
//                    }
//                })
        //}
        self.loading = true
        //let longitude = -90.307697 // STL
        //let latitude = 38.654154
        //let longitude = -76.680093 //BALTIMORE
        //let latitude = 39.442386
        let distance = Int(restaurantSearch.distance*1609)
        var price = "1"
        if(restaurantSearch.price>=2) {
            price += ",2"
            if(restaurantSearch.price>=3) {
                price += ",3"
                if(restaurantSearch.price>=4) {
                    price += ",4"
                }
            }
        }
        let apikey = "f39JuduMAARLpxiyqvPL7-V1WxoxVwxziGeQNtt-h0a4V_nKs19-WJaDNa2uqG7vLFyvFj3c8PuT93h89t_CyRg13kTkTWXHy08x1rol709pnKgW8ET9ACK_l-A2X3Yx"
        let url = URL(string: "https://api.yelp.com/v3/businesses/search?limit=50&latitude=\(self.latitude)&longitude=\(self.longitude)&categories=restaurants&price=\(price)&open_now=\(restaurantSearch.isOpen)&radius=\(distance)")
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let res = try JSONDecoder().decode(RestaurantAPIResponse.self, from: data)
                        
                        //self.restaurants = self.filter(res.businesses).shuffled()
                        self.restaurants = res.businesses.shuffled()
                        self.loading = false
                    } catch let error{
                        print(error)
                    }
                }
            }
        }.resume()
    }
}


struct RestaurantAPIResponse: Decodable{
    //let region : Region
    //let total : Int
    let businesses : [Restaurant]
}

