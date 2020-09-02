//
//  Profile.swift
//  Catfish
//
//  Created by Yak Fishman on 9/1/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//

import Foundation

struct Profile {
    var username: String
    var prefersNotifications: Bool
    var likes: [Restaurant]
    var possibles: [Restaurant]
    var dislikes: [Restaurant]
    var watchlist: [Restaurant]

    var goalDate: Date
    
    static let `default` = Self(username: "y_fishman", prefersNotifications: true, likes: [],possibles: [], dislikes: [], watchlist: [])
    
    init(username: String, prefersNotifications: Bool = true, likes: [Restaurant], possibles: [Restaurant], dislikes: [Restaurant], watchlist: [Restaurant]) {
        self.username = username
        self.prefersNotifications = prefersNotifications
        self.goalDate = Date()
        self.likes = likes
        self.dislikes = dislikes
        self.possibles = possibles
        self.watchlist = watchlist
    }
}
