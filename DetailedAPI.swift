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
    @Published var loading = false
    private func fetchYelpBusinesses(){
        self.loading = true
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
                        self.loading = false
                    } catch let error{
                        print(error)
                    }
                }
            }
        }.resume()
    }
    init(id: String) {
        self.id = id
        fetchYelpBusinesses()
    }
    
    var id: String {
        didSet { fetchYelpBusinesses() }
    }
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
struct Open: Decodable, Hashable {
    let is_overnight : Bool
    let start: String
    let end: String
    let day: Int
}

