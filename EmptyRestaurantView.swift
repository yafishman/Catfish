//
//  EmptyRestaurantView.swift
//  Catfish
//
//  Created by Yak Fishman on 9/6/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//

import SwiftUI

struct EmptyRestaurantView: View {
    var body: some View {
        VStack {
            Text("Uh oh!")
            .font(.largeTitle)
            .fontWeight(.bold)
            Text("You've reached the end of restaurants with your criteria. Broaden your search fields to see more restaurants").multilineTextAlignment(.center).padding()
        }
        
        
    }
}
