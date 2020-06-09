//
//  FilterItem.swift
//  LetsEat
//
//  Created by Krista Nittmann on 6/9/20.
//  Copyright © 2020 MyName. All rights reserved.
//

import Foundation

class FilterItem: NSObject {
    let filter: String
    let name: String
    
    init(dict:[String: AnyObject]) {
        name = dict["name"] as! String
        filter = dict["filter"] as! String
    }
}
