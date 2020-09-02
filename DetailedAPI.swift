//
//  RestaurantAPI.swift
//  Catfish
//
//  Created by Yak Fishman on 8/30/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//

import Foundation
import SwiftUI
import CoreLocation

class DetailedAPI: ObservableObject  {
    @Published private(set) var photos = [String]()
    @Published private(set) var hours = [Hours]()
    
    private func fetchYelpBusinesses(){
        let apikey = "f39JuduMAARLpxiyqvPL7-V1WxoxVwxziGeQNtt-h0a4V_nKs19-WJaDNa2uqG7vLFyvFj3c8PuT93h89t_CyRg13kTkTWXHy08x1rol709pnKgW8ET9ACK_l-A2X3Yx"
        let url = URL(string: "https://api.yelp.com/v3/businesses/\(id)")
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let res = try JSONDecoder().decode(DetailedAPIResponse.self, from: data)

                        self.photos = res.photos
                        self.hours = res.hours
                    } catch let error{
                        print(error)
                    }
                }
            }
        }.resume()
    }
    // create a FlightFetcher with certain search criteria ...
    init(id: String) {
        self.id = id
        fetchYelpBusinesses()
    }
    
    // ... then update the criteria as desired ...
    var id: String {
        didSet { fetchYelpBusinesses() }
    }
    
    // ... and retrieve the latest results here ...
    // @Published private(set) var latest = [Restaurant]()
    
    // MARK: - Private Implementation

    // filters our results based on our flightSearch criteria
       private func filter(_ results: Set<Restaurant>) -> [Restaurant] {
     return results
//     .filter { restaurantSearch.airline == nil || $0.ident.hasPrefix(restaurantSearch.airline!) }
//     .filter { restaurantSearch.origin == nil || $0.origin == restaurantSearch.origin || $0.ident.hasPrefix("K"+restaurantSearch.origin!) }
//     .filter { !restaurantSearch.inTheAir || $0.departure != nil }
     .sorted() // Flight implements Comparable (sorts by arrival time)
     }
     
    // fires off a EnrouteRequest to FlightAware
    // to get a list of flights heading toward our flightSearch.destination airport
    // it runs periodically and publishes any FAFlight objects it finds
    // (we also add all mentioned airports and airlines to Airports.all and Airlines.all here)
    /*private func fetchFlights() {
     flightAwareResultsCancellable = nil
     flightAwareRequest?.stopFetching()
     flightAwareRequest = nil
     let icao = restaurantSearch.destination
     flightAwareRequest = EnrouteRequest.create(airport: icao, howMany: 90)
     flightAwareRequest?.fetch(andRepeatEvery: 30)
     flightAwareResultsCancellable = flightAwareRequest?.results.sink { [weak self] results in
     Airports.all.fetch(icao) // prefetch
     results.forEach {
     Airports.all.fetch($0.origin) // prefetch
     Airlines.all.fetch($0.airlineCode) // prefetch
     }
     self?.latest = self?.filter(results) ?? []
     }
     }
     
     private(set) var flightAwareRequest: EnrouteRequest!
     private var flightAwareResultsCancellable: AnyCancellable?
     */
}


struct DetailedAPIResponse: Decodable{
    let photos : [String]
    let hours : [Hours]
}

struct Hours: Decodable{
    let open : [Open]
    let hours_type : String
    let is_open_now : Bool
}
struct Open: Decodable {
    let is_overnight : Bool
    let start: String
    let end: String
    let day: Int
}

