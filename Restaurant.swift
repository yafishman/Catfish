//
//  Restaurant.swift
//  Catfish
//
//  Created by Yak Fishman on 8/13/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//

import Foundation
struct Restaurant: Comparable, Decodable, Hashable
{
    static func < (lhs: Restaurant, rhs: Restaurant) -> Bool {
        if lhs.distance <= rhs.distance {
            return true
        } else{
            return false
        }
    }
    
    var id: String
    var transactions: [String] //delivery, pickup
    var name: String
    var display_phone : String;
    var phone : String
    var price: String // e.g. "$$"
    var rating: Double // e.g. "4.5"
    var review_count: Int
    var is_closed: Bool // 0 or 1
    var url: String
    var distance: Double
    var distanceMiles: Double {
        return distance/1609.34
    }
    var image_url: String
    var categories: [Category]
    var coordinates: Coordinates // e.g. https://s3-media4.fl.yelpcdn.com/bphoto/V4s343A03sEFj4n_SZgoYw/o.jpg"
    var location: Location
    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
         lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
struct Region: Decodable{
    let center : Coordinates
}
struct Coordinates : Decodable {
    let latitude : Double
    let longitude : Double
}
struct Category : Hashable, Decodable, Comparable {
    static func < (lhs: Category, rhs: Category) -> Bool {
        return lhs.title.lowercased() < rhs.title.lowercased()
    }
    
    //let id = UUID()
    let alias : String
    let title : String
}
struct Location: Decodable{
    let address1 : String
    let city : String
    let country : String
    let display_address : [String]
    let state : String
    let zip_code : String
}
/*struct Restaurant: Codable, Hashable, Identifiable, Comparable, CustomStringConvertible
{
    private var transactions: [String] //delivery, pickup
    private var name: String
    private var phoneNumber: String // e.g. "+19147474601"
    private var price: String // e.g. "$$"
    private var rating: String // e.g. "4.5"
    private var review_count: Int
    var id: String { ident }
    private var isClosed: Bool // 0 or 1
    private var url: String
    private var categories: Any
    private var latitude: String // e.g. https://s3-media4.fl.yelpcdn.com/bphoto/V4s343A03sEFj4n_SZgoYw/o.jpg"
    
    
    
    private(set) var ident: String
    private(set) var aircraft: String
    
    var number: Int { Int(String(ident.drop(while: { !$0.isNumber }))) ?? 0 }
    var airlineCode: String { String(ident.prefix(while: { !$0.isNumber })) }
    
    var departure: Date? { actualdeparturetime > 0 ? Date(timeIntervalSince1970: TimeInterval(actualdeparturetime)) : nil }
    var arrival: Date { Date(timeIntervalSince1970: TimeInterval(estimatedarrivaltime)) }
    var filed: Date { Date(timeIntervalSince1970: TimeInterval(filed_departuretime)) }
    
    private(set) var destination: String
    private(set) var destinationName: String
    private(set) var destinationCity: String
    
    private(set) var origin: String
    private(set) var originName: String
    private(set) var originCity: String
    
    var originFullName: String {
        let origin = self.origin.first == "K" ? String(self.origin.dropFirst()) : self.origin
        if originName.contains(elementIn: originCity.components(separatedBy: ",")) {
            return origin + " " + originCity
        }
        return origin + " \(originName), \(originCity)"
    }
    
    private var actualdeparturetime: Int
    private var estimatedarrivaltime: Int
    private var filed_departuretime: Int
    
    //var id: String { ident }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func ==(lhs: Restaurant, rhs: Restaurant) -> Bool { lhs.id == rhs.id }
    
    static func < (lhs: Restaurant, rhs: Restaurant) -> Bool {
        if lhs.arrival < rhs.arrival {
            return true
        } else if rhs.arrival < lhs.arrival {
            return false
        } else {
            return lhs.departure ?? lhs.filed < rhs.departure ?? rhs.filed
        }
    }

    var description: String {
        if let departure = self.departure {
            return "\(ident) departed \(origin) at \(departure) arriving \(arrival)"
        } else {
            return "\(ident) scheduled to depart \(origin) at \(filed) arriving \(arrival)"
        }
    }
 
}

*/
