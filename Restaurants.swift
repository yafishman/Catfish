//
//  Restaurants.swift
//  Catfish
//
//  Created by Yak Fishman on 9/8/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//

import Foundation
public class Restaurants: NSObject, NSCoding {
    var restaurants: [Restaurant] = []
    enum Key:String {
        case restaurants = "restaurants"
    }
    init(restaurants: [Restaurant]) {
        self.restaurants = restaurants
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(restaurants, forKey: Key.restaurants.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let mRestaurants = aDecoder.decodeObject(forKey: Key.restaurants.rawValue) as! [Restaurant]
        self.init(restaurants: mRestaurants)
    }
}
