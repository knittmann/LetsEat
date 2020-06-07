//
//  LocationItem.swift
//  LetsEat
//
//  Structure to store a location item to be used by LocationDataManager.
//
//  Created by Krista Nittmann on 6/7/20.
//  Copyright © 2020 MyName. All rights reserved.
//

import Foundation

struct LocationItem {
    
    var state: String?
    var city: String?
    
}

extension LocationItem {
    
    /// Initiate the LocationItem
    ///
    /// - Parameter dict: The dictionary
    init(dict: [String: AnyObject]) {
        self.state = dict["state"] as? String
        self.city = dict["city"] as? String
    }
    
    /// Combine the city and state properties into a single String
    ///
    /// Returns: A String containing the city and state properties
    var full: String {
        guard let city = self.city, let state = self.state else {
            return ""
        }
        
        return "\(city), \(state)"
    }
}
