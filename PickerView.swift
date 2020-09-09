//
//  PickerView.swift
//  Catfish
//
//  Created by Yak Fishman on 8/31/20.
//  Copyright © 2020 Yak Fishman. All rights reserved.
//

import SwiftUI

struct PickerView: View {
    @State var categories: [Category] = load("JSONData.json")
    @Binding var selections: [Category]
    
    init(selections: Binding<[Category]>) {
        self._selections = selections
        
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(self.categories, id: \.self) { item in
                    Button(action: {
                        if self.selections.contains(item) {
                            self.selections.removeAll(where: { $0 == item })
                        }
                        else {
                            self.selections.removeAll(where: { $0.title == "Anything" })
                            if item.title == "Anything" {
                                self.selections.removeAll()
                            }
                            self.selections.append(item)
                        }
                    }) {
                        HStack {
                            Text(item.title)
                            if self.selections.contains(item) {
                                Spacer()
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
        }
    }
    
}
func load<Category: Decodable>(_ filename: String) -> [Category] {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode([Category].self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(Category.self):\n\(error)")
    }
}
