//
//  Restaurant.swift
//  Catfish
//
//  Created by Yak Fishman on 8/13/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//

import Foundation
import Combine
public class Restaurant: NSObject, Comparable, Decodable, NSCoding
{
    public static func < (lhs: Restaurant, rhs: Restaurant) -> Bool {
        if lhs.distance <= rhs.distance {
            return true
        } else{
            return false
        }
    }
    
    
    var id: String
    var transactions: [String] //delivery, pickup
    var name: String
    var display_phone : String
    var phone : String;
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
    var coordinates: Coordinates
    var location: Location
    public static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
        lhs.id == rhs.id
    }
    //public func hash(into hasher: inout Hasher) { hasher.combine(id) }
    //static let `default` = Self(id: "null", transactions: [], name: "", display_phone: "", phone: "", price: "", rating: 0.0, review_count: 0, is_closed: true, url: "", distance: 0.0, image_url: "", categories: [], coordinates: Coordinates.default, location: Location.default)
    init(id: String, transactions: [String], name: String, display_phone: String, phone: String, price: String, rating: Double, review_count: Int, is_closed: Bool, url: String, distance: Double, image_url: String, categories: [Category], coordinates: Coordinates, location: Location) {
        self.id = id
        self.transactions = transactions
        self.name = name
        self.display_phone = display_phone
        self.phone = phone
        self.price = price
        self.rating = rating
        self.review_count = review_count
        self.is_closed = is_closed
        self.url = url
        self.distance = distance
        self.image_url = image_url
        self.categories = categories
        self.coordinates = coordinates
        self.location = location
    }
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(transactions, forKey: "transactions")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(display_phone, forKey: "display_phone")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(rating, forKey: "rating")
        aCoder.encode(review_count, forKey: "review_count")
        aCoder.encode(is_closed, forKey: "is_closed")
        aCoder.encode(url, forKey: "url")
        aCoder.encode(distance, forKey: "distance")
        aCoder.encode(distanceMiles, forKey: "distanceMiles")
        aCoder.encode(image_url, forKey: "image_url")
        aCoder.encode(categories, forKey: "categories")
        aCoder.encode(coordinates, forKey: "coordinates")
        aCoder.encode(location, forKey: "location")
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let mId = aDecoder.decodeObject(forKey: "id") as! String
        let mTransactions = aDecoder.decodeObject(forKey: "transactions") as! [String]
        let mName = aDecoder.decodeObject(forKey: "name") as! String
        let mPhone = aDecoder.decodeObject(forKey: "phone") as! String
        let mDispPhone = aDecoder.decodeObject(forKey: "display_phone") as! String
        let mPrice = aDecoder.decodeObject(forKey: "price") as! String
        let mRating = aDecoder.decodeDouble(forKey: "rating")
        let mReview = aDecoder.decodeInteger(forKey: "review_count")
        let mClosed = aDecoder.decodeBool(forKey: "is_closed")
        let mURL = aDecoder.decodeObject(forKey: "url") as! String
        let mDistance = aDecoder.decodeDouble(forKey: "distance")
        //let mMiles = aDecoder.decodeObject(forKey: "distanceMiles") as! Double
        let mImage = aDecoder.decodeObject(forKey: "image_url") as! String
        let mCategories = aDecoder.decodeObject(forKey: "categories") as! [Category]
        let mCoordinates = aDecoder.decodeObject(forKey: "coordinates") as? Coordinates ?? Coordinates(latitude: 0.0)
        let mLocation = aDecoder.decodeObject(forKey: "location") as? Location ?? Location(address: "")
        self.init(id: mId, transactions: mTransactions, name: mName, display_phone: mDispPhone, phone: mPhone,  price: mPrice, rating: mRating, review_count: mReview, is_closed: mClosed, url: mURL, distance: mDistance, image_url: mImage, categories: mCategories, coordinates: mCoordinates, location: mLocation)
        //self.init()
    }
    
    init(id: String) {
        self.id = "null"
        self.transactions = []
        self.name = ""
        self.display_phone = ""
        self.phone = ""
        self.price = ""
        self.rating = 3.0
        self.review_count = 0
        self.is_closed = true
        self.url = ""
        self.distance = 0.0
        self.image_url = ""
        self.categories = []
        self.coordinates = Coordinates(latitude: 0.0)
        self.location = Location(address: "")
        // super.init()
    }
}
class Region: Decodable{
    let center : Coordinates
}
class Coordinates : NSObject, NSCoding, Decodable {
    let latitude : Double
    let longitude : Double
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    init(latitude: Double) {
        self.latitude = 0.0
        self.longitude = 0.0
    }
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let mlatitude = aDecoder.decodeDouble(forKey: "latitude")
        let mLongitude = aDecoder.decodeDouble(forKey: "longitude")
        self.init(latitude: mlatitude, longitude: mLongitude)
    }
}
class Category : NSObject, NSCoding, Decodable, Comparable {
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.title.lowercased() == rhs.title.lowercased()
    }
    
    static func < (lhs: Category, rhs: Category) -> Bool {
        return lhs.title.lowercased() < rhs.title.lowercased()
    }
    //public func hash(into hasher: inout Hasher) { hasher.combine(alias) }
    
    //let id = UUID()
    init(alias: String) {
        self.alias = "anything"
        self.title = "Anything"
    }
    init(alias: String, title: String) {
        self.alias = alias
        self.title = title
    }
    let alias : String
    let title : String
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(alias, forKey: "alias")
        aCoder.encode(title, forKey: "title")
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let mAlias = aDecoder.decodeObject(forKey: "alias") as! String
        let mTitle = aDecoder.decodeObject(forKey: "title") as! String
        self.init(alias: mAlias, title: mTitle)
    }
}
class Location: NSObject, NSCoding, Decodable{
    let address1 : String
    let city : String
    let country : String
    let display_address : [String]
    let state : String
    let zip_code : String
    //static let `default` = Self(address1: "", city: "", country: "", display_address: [], state: "", zip_code: "")
    init(address1: String, city: String, country: String, display_address: [String], state: String, zip_code: String) {
        self.address1 = address1
        self.city = city
        self.country = country
        self.display_address = display_address
        self.state = state
        self.zip_code = zip_code
    }
    init(address: String) {
        address1 = ""
        city = ""
        country = ""
        display_address = []
        state = ""
        zip_code = ""
    }
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(address1, forKey: "address1")
        aCoder.encode(city, forKey: "city")
        aCoder.encode(country, forKey: "country")
        aCoder.encode(display_address, forKey: "display_address")
        aCoder.encode(state, forKey: "state")
        aCoder.encode(zip_code, forKey: "zip_code")
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let mAddress1 = aDecoder.decodeObject(forKey: "address1") as! String
        let mCity = aDecoder.decodeObject(forKey: "city") as! String
        let mCountry = aDecoder.decodeObject(forKey: "country") as! String
        let mDisplay = aDecoder.decodeObject(forKey: "display_address") as! [String]
        let mState = aDecoder.decodeObject(forKey: "state") as! String
        let mZip = aDecoder.decodeObject(forKey: "zip_code") as! String
        self.init(address1: mAddress1, city: mCity, country: mCountry, display_address: mDisplay, state: mState, zip_code: mZip)
    }
}


