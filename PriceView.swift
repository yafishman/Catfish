//
//  PriceView.swift
//  Catfish
//
//  Created by Yak Fishman on 8/30/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//

import SwiftUI

struct PriceView: View {
    var price: String
    var body: some View {
        let length = price.count
        return HStack {
            ForEach(0..<length, id: \.self) {_ in 
                Image(systemName: "dollarsign.circle")
            }
        }
        
    }
}

struct PriceView_Previews: PreviewProvider {
    static var previews: some View {
        PriceView(price: "$$$")
    }
}
