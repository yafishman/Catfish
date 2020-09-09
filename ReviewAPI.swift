//
//  ReviewAPI.swift
//  Catfish
//
//  Created by Yak Fishman on 9/2/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//

import Foundation
import SwiftUI
import CoreLocation

class ReviewAPI: ObservableObject  {
    @Published private(set) var reviews = [Review]()
    
    private func fetchYelpBusinesses(){
        let apikey = "f39JuduMAARLpxiyqvPL7-V1WxoxVwxziGeQNtt-h0a4V_nKs19-WJaDNa2uqG7vLFyvFj3c8PuT93h89t_CyRg13kTkTWXHy08x1rol709pnKgW8ET9ACK_l-A2X3Yx"
        
        let url = URL(string: "https://api.yelp.com/v3/businesses/\(id)/reviews")
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let res = try JSONDecoder().decode(ReviewAPIResponse.self, from: data)
                        self.reviews = res.reviews
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
    private func filter(results: [Review]) -> [Review] {
        return results.sorted {$0.time_created > $1.time_created}
    }
}


struct ReviewAPIResponse: Decodable{
    let reviews : [Review]
}

struct Review: Hashable, Decodable{
    static func == (lhs: Review, rhs: Review) -> Bool {
        lhs.id==rhs.id
    }
    
    let id: String
    let rating: Int
    let user: User
    let text: String
    let time_created: String
}
struct User: Hashable, Decodable{
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id==rhs.id
    }
    let id: String
    let name : String
}

