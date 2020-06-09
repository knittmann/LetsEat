//
//  ReviewItem.swift
//  LetsEat
//
//  Created by Krista Nittmann on 6/9/20.
//  Copyright © 2020 MyName. All rights reserved.
//

import UIKit

struct ReviewItem {
    var rating: Float?
    var name: String?
    var title: String?
    var customerReview: String?
    var date: Date?
    var restaurantID: Int?
    var uuid = UUID().uuidString
    
    var displayDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        
        guard let reviewData = date else { return "" }
        
        return formatter.string(from: reviewData as Date)
    }
}

extension ReviewItem {
    
    /// Create a `ReviewItem` instance and map the attributes from `Review` to the properties of the `ReviewItem` instance.
    init(data: Review) {
        if let reviewDate = data.date {
            self.date = reviewDate
        }
        
        self.customerReview = data.customerReview
        self.name = data.name
        self.title = data.title
        self.restaurantID = Int(data.restaurantID)
        self.rating = data.rating
        if let uuid = data.uuid { self.uuid = uuid}
    }
    
}
