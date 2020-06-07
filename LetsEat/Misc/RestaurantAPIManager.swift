//
//  RestaurantAPIManager.swift
//  LetsEat
//
//  Data manager class that loads data from JSON files
//  
//  Created by Krista Nittmann on 6/6/20.
//  Copyright © 2020 MyName. All rights reserved.
//

import Foundation

struct RestaurantAPIManager {
    
    // Return an array of dictionaries containing JSON data of a file
    static func loadJSON(file name: String) -> [[String: AnyObject]] {
        var items = [[String: AnyObject]]()
        guard let path = Bundle.main.path(forResource: name, ofType: "json"), let data = NSData(contentsOfFile: path) else {
            return [[:]]
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as AnyObject
            
            if let restaurants = json as? [[String: AnyObject]] {
                items = restaurants as [[String: AnyObject]]
            }
        }
        catch {
            print("error serializing JSON: \(error)")
            items = [[:]]
        }
        return items
    }
}
