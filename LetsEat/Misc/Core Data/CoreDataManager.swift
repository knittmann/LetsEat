//
//  CoreDataManager.swift
//  LetsEat
//
//  Sets up the Core Data componenets for the app.
//
//  Created by Krista Nittmann on 6/9/20.
//  Copyright © 2020 MyName. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    
    let container: NSPersistentContainer
    
    override init() {
        container = NSPersistentContainer(name: "LetsEatModel")
        
        container.loadPersistentStores{ (storeDesc, error) in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
        }
        super.init()
    }
    
    /// Take a `ReviewItem` instance as a parameter and gets an empty `Review` object from the context.  The properties of the `ReviewItem` instance are assigned to the attributes of `Review` object, and the `save()` method is called to save the context to the persistent store.
    func addReview(_ item: ReviewItem) {
        let review = Review(context: container.viewContext)
        review.name = item.name
        review.title = item.title
        review.date = Date()
        
        if let rating = item.rating{ review.rating = rating }
        
        review.customerReview = item.customerReview
        review.uuid = item.uuid
        
        if let id = item.restaurantID {
            review.restaurantID = Int32(id)
            print("restaurant id \(id)")
            save()
        }
    }
    
    /// Similar to `addReview` but for a photo.
    func addPhoto(_ item: RestaurantPhotoItem) {
        let photo = RestaurantPhoto(context: container.viewContext)
        photo.date = Date()
        photo.photo = item.photoData as Data
        photo.uuid = item.uuid
        
        if let id = item.restaurantID {
            photo.restaurantID = Int32(id)
            print("restaurant id \(id)")
            save()
        }
    }
    
    func fetchReviews(by identifier: Int) -> [ReviewItem] {
        
        /// Get a reference to `NSManagedObjectContext`.
        let moc = container.viewContext
        
        /// Get `Review NSManagedObjects` from the persistent store.
        let request: NSFetchRequest<Review> = Review.fetchRequest()
        
        /// Create a fetch predicate that only gets those `Review` objects with the specified `RestaurantID` and store in `items` array.
        let predicate = NSPredicate(format: "restaurantID = %i", Int32(identifier))
        var items: [ReviewItem] = []
        
        /// Sort the results of the request by date.
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        /// Set the predicate for the fetch request.
        request.predicate = predicate
        
        /// Perform the fetch request and place the results in the `items` array.
        do {
            for data in try moc.fetch(request) {
                items.append(ReviewItem(data: data))
            }
            return items
        } catch {
            fatalError("Failed to fetch reviews: (error)")
        }
    }
    
    /// Works the same way as `fetchReviews()`.
    func fetchPhotos(by identifier: Int) -> [RestaurantPhotoItem] {
        let moc = container.viewContext
        let request: NSFetchRequest<RestaurantPhoto> = RestaurantPhoto.fetchRequest()
        let predicate = NSPredicate(format: "restaurantID = %1", Int32(identifier))
        var items: [RestaurantPhotoItem] = []
        
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        request.predicate = predicate
        
        do {
            for data in try moc.fetch(request) {
                items.append(RestaurantPhotoItem(data: data))
            }
            return items
        } catch {
            fatalError("Failed to fetch photos: (error)")
        }
    }
    
    fileprivate func save() {
        
        do {
            if container.viewContext.hasChanges {
                try container.viewContext.save()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }

}
