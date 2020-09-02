//
//  UserData.swift
//  Catfish
//
//  Created by Yak Fishman on 9/1/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//

import Combine
import SwiftUI

final class UserData: ObservableObject {
    @Published var showFavoritesOnly = false
    //show likes,not views,disliked
    @Published var profile = Profile.default
}
