//
//  RestaurantDetailViewController.swift
//  LetsEat
//
//  Created by admin on 03/12/2019.
//  Copyright © 2019 MyName. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailViewController: UITableViewController {
    
    // Nav Bar
    @IBOutlet weak var btnHeart: UIBarButtonItem!
    
    // Cell One
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCuisine: UILabel!
    @IBOutlet weak var lblHeaderAddress: UILabel!
    
    // Cell Two
    @IBOutlet weak var lblTableDetails: UILabel!
    
    // Cell Three
    @IBOutlet weak var lblOverallRating: UILabel!
    @IBOutlet weak var ratingView: RatingsView!
    
    // Cell Eight
    @IBOutlet weak var lblAddress: UILabel!
    
    // Cell Nine
    @IBOutlet weak var imgMap: UIImageView!
    
    var selectedRestaurant: RestaurantItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
}

private extension RestaurantDetailViewController {
    
    /// Dismiss the review form screen
    @IBAction func unwindReviewCancel(segue: UIStoryboardSegue) {}
    
    /// Temporary method to hard-assign a rating for testing purposes.
    func createRating() {
        ratingView.rating = 3.5
        
        /// Setting the `isEnabled` property to `true` allows the ratings view to become the first responder and begin tracking touches, which will trigger `handle(with:)`, which in turn calls `updateRating(with:)`
        ratingView.isEnabled = true
    }
    
    func initialize() {
        setupLabels()
        createMap()
        createRating()
    }
    
    func setupLabels() {
        guard let restaurant = selectedRestaurant else { return }
        
        if let name = restaurant.name {
            lblName.text = name
            title = name
        }
        
        if let cuisine = restaurant.subtitle {
            lblCuisine.text = cuisine
        }
        
        if let address = restaurant.address {
            lblAddress.text = address
            lblHeaderAddress.text = address
        }
        
        lblTableDetails.text = "Table for 7, tonight at 10:00 PM"
    }
    
    func createMap() {
        guard let annotation = selectedRestaurant,
            let long = annotation.long,
            let lat = annotation.lat else { return }
        
        let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        takeSnapShot(with: location)
    }
    
    /// Given a location, this method takes a snapshot of the map at that location, adds the custom annotation used in the Map screen, converts it into an image, and assigns it to the imgMap outlet.
    ///
    /// - Parameter location: <#location description#>
    func takeSnapShot(with location: CLLocationCoordinate2D) {
        let mapSnapshotOptions = MKMapSnapshotter.Options()
        var loc = location
        let polyline = MKPolyline(coordinates: &loc, count: 1)
        let region = MKCoordinateRegion(polyline.boundingMapRect)
        
        mapSnapshotOptions.region = region
        mapSnapshotOptions.scale = UIScreen.main.scale
        mapSnapshotOptions.size = CGSize(width: 340, height: 208)
        mapSnapshotOptions.showsBuildings = true
        mapSnapshotOptions.pointOfInterestFilter = .includingAll
        
        let snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
        
        snapShotter.start() { snapshot, error in guard
            let snapshot = snapshot else { return }
            UIGraphicsBeginImageContextWithOptions(mapSnapshotOptions.size, true, 0)
            snapshot.image.draw(at: .zero)
            
            let identifier = "custompin"
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            pinView.image = UIImage(named: "custom-annotation")!
            let pinImage = pinView.image
            var point = snapshot.point(for: location)
            
            let rect = self.imgMap.bounds
            if rect.contains(point) {
                let pinCenterOffset = pinView.centerOffset
                point.x -= pinView.bounds.size.width/2
                point.y -= pinView.bounds.size.height/2
                point.x += pinCenterOffset.x
                point.y += pinCenterOffset.y
                pinImage?.draw(at: point)
            }
            
            if let image = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                DispatchQueue.main.async {
                    self.imgMap.image = image
                }
            }
        }
    }
}
