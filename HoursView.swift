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
    var days: [String] = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    var body: some View {
        VStack {
            ForEach(0..<7) { number in
                if(self.getIndex(number: number) == -1) {
                    Text("\(self.days[number]): Closed")
                }
                else {
                    self.display(day: number, number: self.getIndex(number: number))
                }
            }
        }
    }
    func getIndex(number: Int) -> Int{
        return hours.firstIndex(where: {$0.day==number}) ?? -1
    }
    func display(day: Int,number: Int) -> some View{
        return self.displayHelp(day: self.days[day], start: self.hours[number].start, end: self.hours[number].end)
    }
    func displayHelp(day: String,start: String, end: String) -> some View {
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

