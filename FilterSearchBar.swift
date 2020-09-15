//
//  FilterSearchBar.swift
//  Catfish
//
//  Created by Yak Fishman on 9/14/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//

import SwiftUI
import UIKit
import MapKit

struct FilterSearchBar: View {
    @Binding var text: String
    @State var places: [MKMapItem] = []
    
    @State private var isEditing = false
    let searchRequest = MKLocalSearch.Request()
    var body: some View {
        VStack {
            HStack {
                
                TextField("Search ...", text: $text)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                            
                            if isEditing {
                                Button(action: {
                                    self.text = ""
                                    
                                }) {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 8)
                                    
                                }
                            }
                        }
                )
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        self.isEditing = true
                }
                
                if isEditing {
                    Button(action: {
                        self.isEditing = false
                        self.text = ""
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        
                    }) {
                        Text("Cancel")
                    }
                    .padding(.trailing, 10)
                    .transition(.move(edge: .trailing))
                    .animation(.default)
                }
            }
            test()
        }
        
        
    }
    func test() -> some View {
        self.searchRequest.naturalLanguageQuery = self.text
        let search = MKLocalSearch(request: self.searchRequest)
        var results : [MKMapItem] = []
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            results = response.mapItems
                        for item in response.mapItems {
                            print(item.name ?? "No phone number.")
                        }
        }
        //self.places = results
        return self.results(results: results)
    }
    func results(results: [MKMapItem]) -> some View {
        return List {
            ForEach(self.places, id: \.self) { place in
                
                Text("response \(place.name!)")
            }
        }
    }
}
