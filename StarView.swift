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
        if(rating-Double(flor)==0.5) {
            return Image("extra_large_\(flor)_half")
        } else {
            return Image("extra_large_\(flor)")
        }
    }
}

struct StarView_Previews: PreviewProvider {
    static var previews: some View {
        StarView(rating: 4.5)
    }
}
