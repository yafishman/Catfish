//
//  UserData.swift
//  Catfish
//
//  Created by Yak Fishman on 9/1/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//

import Combine
import SwiftUI
import CoreData


final class UserData: ObservableObject {
    @Published var showFavoritesOnly = false
    //show likes,not views,disliked
    //@Published var profile = Profile.default
    @Published var username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    @Published var prefersNotifications: Bool = UserDefaults.standard.bool(forKey: "notifications")
    @Published var likes: [Restaurant] = []
    @Published var possibles: [Restaurant] = []
    @Published var dislikes: [Restaurant] = []
    @Published var watchlist: [Restaurant] =  []
    @Published var visited: [Restaurant] = []
    init() {
        //createData()
        getSavedData()
    }
    func getSavedData() {
        getVisited()
        getLikes()
        getDislikes()
        getWatchlist()
    }
    
    func getLikes(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Likes")
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            for data in result as! [NSManagedObject] {
                let mlikes = data.value(forKey: "likes") as! Restaurants
                self.likes = mlikes.restaurants
            }
        } catch {
            print("failed")
        }
        
    }
    
    func getDislikes(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Dislikes")
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            for data in result as! [NSManagedObject] {
                let mdislikes = data.value(forKey: "dislikes") as! Restaurants
                self.dislikes = mdislikes.restaurants
            }
        } catch {
            print("failed")
        }
        
    }
    func getWatchlist(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Watchlist")
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            for data in result as! [NSManagedObject] {
                let mwatchlist = data.value(forKey: "watchlist") as! Restaurants
                self.watchlist = mwatchlist.restaurants
            }
        } catch {
            print("failed")
        }
        
    }
    func getVisited(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Visited")
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            for data in result as! [NSManagedObject] {
                let mvisited = data.value(forKey: "visited") as! Restaurants
                self.visited = mvisited.restaurants
            }
        } catch {
            print("failed")
        }
        
    }
    
}
