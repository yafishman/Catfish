//
//  StarView.swift
//  Catfish
//
//  Created by Yak Fishman on 8/30/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//

import SwiftUI

struct StarView: View {
    var rating: Double
    var body: some View {
        let flor = Int(rating)
        return HStack {
            ForEach(0..<flor, id: \.self) {_ in
                Image(systemName: "star.fill")
            }
            if(floor(rating) != rating) {
                Image(systemName: "star.lefthalf.fill")
            }
            
        }
    }
}

struct StarView_Previews: PreviewProvider {
    static var previews: some View {
        StarView(rating: 4.5)
    }
}
