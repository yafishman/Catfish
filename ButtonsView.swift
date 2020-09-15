//
//  ButtonsView.swift
//  Catfish
//
//  Created by Yak Fishman on 9/7/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//

import SwiftUI
import CoreData

struct ButtonsView: View {
    var current: Restaurant
    @EnvironmentObject var userData: UserData
    var spacing: CGFloat = 50
    var body: some View {
        HStack(spacing: self.spacing) {
            Button(action: {
                if self.userData.visited.contains(where: {$0.id==self.current.id}) {
                    self.userData.visited.removeAll {$0.id==self.current.id}
                    self.deleteData(id: self.current.id, list: "Visited")
                } else {
                    self.userData.visited.append(self.current)
                    self.addData(restaurants: self.userData.visited, list: "Visited")
                    self.userData.watchlist.removeAll {$0.id==self.current.id}
                    self.deleteData(id: self.current.id, list: "Watchlist")
                    
                }
                
            }) {
                if self.userData.visited.contains(where: {$0.id==self.current.id}) {
                    Image(systemName: "tortoise.fill")
                } else {
                    Image(systemName: "tortoise")
                }
            }
            Button(action: {
                if self.userData.dislikes.contains(where: {$0.id==self.current.id}) {
                    self.userData.dislikes.removeAll {$0.id==self.current.id}
                    self.deleteData(id: self.current.id, list: "Dislikes")
                    
                } else {
                    self.userData.dislikes.append(self.current)
                    self.addData(restaurants: self.userData.dislikes, list: "Dislikes")
                    
                    if !self.userData.visited.contains(where: {$0.id==self.current.id}) {
                        self.userData.visited.append(self.current)
                        self.addData(restaurants: self.userData.visited, list: "Visited")
                    }
                    self.userData.watchlist.removeAll {$0.id==self.current.id}
                    self.userData.likes.removeAll {$0.id==self.current.id}
                    self.deleteData(id: self.current.id, list: "Likes")
                    self.deleteData(id: self.current.id, list: "Watchlist")
                    
                }
            }) {
                if self.userData.dislikes.contains(where: {$0.id==self.current.id}) {
                    Image(systemName: "hand.thumbsdown.fill").foregroundColor(.red)
                } else {
                    Image(systemName: "hand.thumbsdown")
                }
                
            }
            Button(action: {
                if self.userData.watchlist.contains(where: {$0.id==self.current.id}) {
                    self.userData.watchlist.removeAll {$0.id==self.current.id}
                    self.deleteData(id: self.current.id, list: "Watchlist")
                    
                    
                } else {
                    self.userData.watchlist.append(self.current)
                    self.addData(restaurants: self.userData.watchlist, list: "Watchlist")
                    self.userData.dislikes.removeAll {$0.id==self.current.id}
                    self.userData.likes.removeAll {$0.id==self.current.id}
                    self.deleteData(id: self.current.id, list: "Dislikes")
                    self.deleteData(id: self.current.id, list: "Likes")
                    
                }
            }) {
                if self.userData.watchlist.contains(where: {$0.id==self.current.id}) {
                    Image(systemName: "bookmark.fill").foregroundColor(.orange)
                } else {
                    Image(systemName: "bookmark")
                }
            }
            Button(action: {
                if self.userData.likes.contains(where: {$0.id==self.current.id}) {
                    self.userData.likes.removeAll {$0.id==self.current.id}
                    self.deleteData(id: self.current.id, list: "Likes")
                    
                } else {
                    self.userData.likes.append(self.current)
                    self.addData(restaurants: self.userData.likes, list: "Likes")
                    
                    if !self.userData.visited.contains(where: {$0.id==self.current.id}) {
                        self.userData.visited.append(self.current)
                        self.addData(restaurants: self.userData.visited, list: "Visited")
                    }
                    self.userData.watchlist.removeAll {$0.id==self.current.id}
                    self.userData.dislikes.removeAll {$0.id==self.current.id}
                    self.deleteData(id: self.current.id, list: "Dislikes")
                    self.deleteData(id: self.current.id, list: "Watchlist")
                    
                }
            }) {
                if self.userData.likes.contains(where: {$0.id==self.current.id}) {
                    Image(systemName: "hand.thumbsup.fill").foregroundColor(.green)
                } else {
                    Image(systemName: "hand.thumbsup")
                }
            }
        }
    }
    func addData(restaurants: [Restaurant], list: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: list, in: managedContext)!
        let cmsg = NSManagedObject(entity: userEntity, insertInto: managedContext)
        let lowercase = list.lowercased()
        if(lowercase=="visited") {
            let mRestaurants = Restaurants(restaurants: userData.visited)
            cmsg.setValue(mRestaurants, forKeyPath: "visited")
        } else if(lowercase=="likes") {
            let mRestaurants = Restaurants(restaurants: userData.likes)
            cmsg.setValue(mRestaurants, forKeyPath: "likes")
        } else if(lowercase=="dislikes") {
            let mRestaurants = Restaurants(restaurants: userData.dislikes)
            cmsg.setValue(mRestaurants, forKeyPath: "dislikes")
        } else if(lowercase=="watchlist") {
            let mRestaurants = Restaurants(restaurants: userData.watchlist)
            cmsg.setValue(mRestaurants, forKeyPath: "watchlist")
        }
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func deleteData(id: String, list: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: list)
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let results =  try managedContext.fetch(fetchRequest)
            for managedObject in results  as! [NSManagedObject]
            {
                let mData = managedObject.value(forKey: list.lowercased()) as! Restaurants
                let temp = mData.restaurants.filter { $0.id == id }
                managedContext.delete(managedObject)
                self.addData(restaurants: temp, list: list)
            }
            try managedContext.save()
        } catch let error as NSError {
            print("error : \(error) \(error.userInfo)")
        }
    }
}

