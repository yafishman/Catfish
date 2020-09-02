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
    
    init(restaurantSearch: RestaurantSearch) {
        self.restaurantSearch = restaurantSearch
        fetchYelpBusinesses()
    }
    
    // ... then update the criteria as desired ...
    var restaurantSearch: RestaurantSearch {
        didSet { fetchYelpBusinesses() }
    }
    
    private func fetchYelpBusinesses(){
        let longitude = -90.307697
        let latitude = 38.654154
        let distance = Int(restaurantSearch.distance*1609)
        var price = "1"
        if(restaurantSearch.price>=2) {
            price += ",2"
            if(restaurantSearch.price>=3) {
                price += ",3"
                if(restaurantSearch.price>=4) {
                    price += ",4"
                    if(restaurantSearch.price>=5) {
                        price += ",5"
                    }
                }
            }
        }
        let apikey = "f39JuduMAARLpxiyqvPL7-V1WxoxVwxziGeQNtt-h0a4V_nKs19-WJaDNa2uqG7vLFyvFj3c8PuT93h89t_CyRg13kTkTWXHy08x1rol709pnKgW8ET9ACK_l-A2X3Yx"
        let url = URL(string: "https://api.yelp.com/v3/businesses/search?latitude=\(latitude)&longitude=\(longitude)&categories=restaurants&price=\(price)&open_now=\(restaurantSearch.isOpen)&radius=\(distance)")
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let res = try JSONDecoder().decode(RestaurantAPIResponse.self, from: data)
                        
                        self.restaurants = self.filter(res.businesses).shuffled()
                        print(self.restaurants.count)
                    } catch let error{
                        print(error)
                    }
                }
            }
        }.resume()
    }
    // create a FlightFetcher with certain search criteria ...

    
    // ... and retrieve the latest results here ...
    
    // MARK: - Private Implementation
    
    // filters our results based on our flightSearch criteria
    private func filter(_ results: [Restaurant]) -> [Restaurant] {
        var end = results.filter { $0.rating >= Double(restaurantSearch.rating) }
        if(restaurantSearch.transactions.contains("delivery")) {
            end = end.filter {
                $0.transactions.contains("delivery")
            }
        }
        if(restaurantSearch.transactions.contains("pickup")) {
            end = end.filter {
                $0.transactions.contains("pickup")
            }
        }
        
        return end
    }
  
}


struct RestaurantAPIResponse: Decodable{
    let region : Region
    let total : Int
    let businesses : [Restaurant]
}

