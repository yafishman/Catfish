//
//  HoursView.swift
//  Catfish
//
//  Created by Yak Fishman on 8/31/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//

import SwiftUI

struct HoursView: View {
    var hours: [Open]
    var body: some View {
        VStack {
            self.display(day: "Monday", start: hours[0].start, end: hours[0].end)
            self.display(day: "Tuesday", start: hours[1].start, end: hours[1].end)
            self.display(day: "Wednesday", start: hours[2].start, end: hours[2].end)
            self.display(day: "Thursday", start: hours[3].start, end: hours[3].end)
            self.display(day: "Friday", start: hours[4].start, end: hours[4].end)
            self.display(day: "Saturday", start: hours[5].start, end: hours[5].end)
            if(hours.count>6) {
                self.display(day: "Sunday", start: hours[6].start, end: hours[6].end)
            } else {
                Text("Sunday: Closed")
            }
        }
    }

    func display(day: String,start: String, end: String) -> some View {
        return Text("\(day): \(fix(time: start)) - \(fix(time: end))")
    }
    func fix(time: String) -> String {
        let num = Int(time) ?? 0
        if(num >= 2200) {
            let new = String(num-1200)
            return("\(new.prefix(2)):\(new.suffix(2)) PM")
        } else if(num > 1200) {
            let new = String(num-1200)
            return("\(new.prefix(1)):\(new.suffix(2)) PM")
        } else if(num == 1200) {
            return("Noon")
        } else if(num == 0) {
            return("Midnight")
        }
        else {
            return("\(time.prefix(2)):\(time.suffix(2)) AM")
        }
        
    }
}

