//
//  RestaurantDataManager.swift
//  LetsEat
//
//  Created by Krista Nittmann on 6/7/20.
//  Copyright © 2020 MyName. All rights reserved.
//

import Foundation

class RestaurantDataManager {
    private var items: [RestaurantItem] = []
    
    func fetch(by location: String, with filter: String = "All", completionHandler:(_ items: [RestaurantItem]) -> Void) {
        
        /// Get the path of the JSON file in the app bundle
        if let file = Bundle.main.url(forResource: location, withExtension: "json") {
            do {
                /// Attempt to assign the contents of `file` to `data`.
                let data = try Data(contentsOf: file)
                
                /// Attempt to parse `data` and decode it as an array of  `RestaurantItem` instances.
                let restaurants = try JSONDecoder().decode([RestaurantItem].self, from: data)
                
                /// If f`filter` is not "All", the `filter` method is applied to the `restaurants` array which results in an
                /// array of `RestaurantItem` instances where the `cuisines` property contains the `filter` value.
                if filter != "All" {
                    items = restaurants.filter({ ($0.cuisines.contains(filter))})
                } else {
                    items = restaurants
                }
            }
            catch {
                print("there was an error \(error)")
            }
        }
        completionHandler(items)
    }
    
    /// Return the number of items in the `items` array.
    ///
    /// - Returns: Int count of `items` array.
    func numberOfItems() -> Int {
        return items.count
    }
    
    /// Get the `RestaurantItem` from the `items` array located at the given `index`.
    ///
    /// - Parameter index: <#index description#>
    /// - Returns: <#description#>
    func restaurantItem(at index: IndexPath) -> RestaurantItem {
        return items[index.item]
    }
}
