//
//  LocationDataManager.swift
//  LetsEat
//
//  Created by admin on 03/12/2019.
//  Copyright © 2019 MyName. All rights reserved.
//

import Foundation

class LocationDataManager {
    
    /// Store city and state information in an array of LocationItem instances.
    private var locations: [LocationItem] = []
    /// Store city and state information in an array of strings.
    // private var locations: [String] = []
    
    func fetch() {
        for location in loadData() {
            /// Get each dictionary provided in the `loadData()` method and use it to initialize LocationItem instances and
            /// append them  to the locations array.
            locations.append(LocationItem(dict: location))
            
            /// Earlier code.
//            if let city = location["city"] as? String, let state = location["state"] as? String {
//                locations.append("\(city), \(state)")
            }
        }
    
    func numberOfItems() -> Int {
        return locations.count
    }
    
    /// <#Description#>
    /// - Parameter index: <#index description#>
    /// - Returns: A LocationItem instance
    func locationItem(at index: IndexPath) -> LocationItem {
        return locations[index.item]
    }
    
    private func loadData() -> [[String: AnyObject]] {
        guard let path = Bundle.main.path(forResource: "Locations", ofType: "plist"), let items = NSArray(contentsOfFile: path) else {
            return [[:]]
        }
        return items as! [[String:AnyObject]]
    }
    
    
    /// Search the locations array for a given city.
    ///
    /// - Parameter name: The city to search for in the `locations` array.
    /// - Returns:True and the index where that array item is stored as a single value if the city is found, false and index 0 if not.
    func findLocation(by name: String) -> (isFound: Bool, position: Int) {
        guard let index = locations.firstIndex(where: {
            $0.city == name
        }) else {
            return (isFound: false, position: 0)
        }
        return (isFound: true, position: index)
    }
}
