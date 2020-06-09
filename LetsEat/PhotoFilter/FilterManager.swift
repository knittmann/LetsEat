//
//  FilterManager.swift
//  LetsEat
//
//  Created by Krista Nittmann on 6/9/20.
//  Copyright © 2020 MyName. All rights reserved.
//

import Foundation

/// Conforms to the `DataManager` protocol created earlier in Chapter 16.
class FilterManager: DataManager {
    
    /// Load data from `FilterData.plist`, create an array of `FilterItem` objects, and assign it to `items`.
    func fetch(completionHandler:(_ items:[FilterItem]) -> Swift.Void) {
        
        var items: [FilterItem] = []
        for data in load(file: "FilterData") {
            items.append(FilterItem(dict: data))
        }
        completionHandler(items)
    }
}
