//
//  ListView.swift
//  Catfish
//
//  Created by Yak Fishman on 9/2/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//

import SwiftUI
import CoreData


struct ListView: View {
    @EnvironmentObject private var userData: UserData
    var title: String
    @Binding var isPresented: Bool
    var body: some View {
        NavigationView {
            List {
                ForEach(userData.possibles, id: \.self) { restaurant in
                    NavigationLink(
                        destination: DetailedView(restaurant, isPresented: self.$isPresented)
                    ) {
                        RestaurantRow(restaurant: restaurant, isLiked: self.userData.likes.contains(where: {$0.id==restaurant.id}),
                                      isDisliked: self.userData.dislikes.contains(where: {$0.id==restaurant.id}),
                                      isWatched: self.userData.watchlist.contains(where: {$0.id==restaurant.id}))
                    }
                }.onDelete(perform: delete)
                
            }.navigationBarTitle(Text("\(title) Restaurants")).navigationBarItems(trailing: deleteAll)
        }
    }
    var deleteAll: some View {
        Button("Delete All") {
            self.userData.possibles.removeAll()
        }
    }
    func delete(at offsets: IndexSet) {
        userData.possibles.remove(atOffsets: offsets)
    }
    func deleteAllData()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Visited")
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results =  try managedContext.fetch(fetchRequest)
            for managedObject in results  as! [NSManagedObject]
            {
                managedContext.delete(managedObject)
            }
            try managedContext.save()
        } catch let error as NSError {
            print("error : \(error) \(error.userInfo)")
        }
    }
}
