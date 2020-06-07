//
//  ExploreViewController.swift
//  LetsEat
//
//  Created by admin on 28/11/2019.
//  Copyright © 2019 MyName. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController,  UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let manager = ExploreDataManager()
    
    /// Store the location passed to `ExploreViewController` by `LocationViewController`.
    var selectedCity: LocationItem?
    /// Allow `ExploreViewController` to set the value for `lblLocation`.
    var headerView: ExploreHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    /// Call `showLocationList` or `showRestaurantListing` depending on the segue to be executed.
    ///
    /// - Parameters:
    ///   - segue: Which segue to execute.
    ///   - sender: Any.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case Segue.locationList.rawValue:
            showLocationList(segue: segue)
        case Segue.restaurantList.rawValue:
            showRestaurantListing(segue: segue)
        default:
            print("Segue not added.")
        }
    }
    
    /// Check whether `selectedCity` is set before transitioning to `RestaurantListViewController`.
    ///
    /// - Parameters:
    ///   - identifier: The segue identifier.
    ///   - sender: Any sender.
    /// - Returns: True or false depending on whether `selectedCity` is set.
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == Segue.restaurantList.rawValue {
            guard selectedCity != nil else {
                showAlert()
                return false
            }
            return true
        }
        return true
    }
}

// MARK: Private Extension
private extension ExploreViewController {
    
    func initialize() {
        manager.fetch()
    }
    
    /// Called before `ExploreViewController` transitions to `LocationViewController` to see if a city has already been
    /// selected.
    ///
    /// - Parameter segue: The segue between `ExploreViewController` and `LocationViewController`.
    func showLocationList(segue: UIStoryboardSegue) {
        
        /// Check whether the segue destination is `UINavigationController` and whether `topViewController` is `LocationViewController`.
        guard let navController = segue.destination as? UINavigationController, let viewController = navController.topViewController as? LocationViewController else {
            return
        }
        
        /// Check to see if the `selectedCity` property of `ExploreViewController` contains a value.
        guard let city = selectedCity else {
            return
        }
        
        /// Assign `city` to the `selectedCity` property of `LocationViewController'`
        viewController.selectedCity = city
    }
    
    /// Called before `ExploreViewController` transitions to `RestaurantListViewController` to set the `selectedCity` and `selectedType` properties. The `selectedCity` property is required for this method to work.
    ///
    /// - Parameter segue: The segue between `ExploreViewController` and `RestaurantListViewController`.
    func showRestaurantListing(segue: UIStoryboardSegue) {
        
        /// Check whether the destination view controller is `RestaurantListViewController`, set `city` to
        /// `selectedCity`, and get the index of the collection view cell the user tapped.
        if let viewController = segue.destination as? RestaurantListViewController, let city = selectedCity, let index = collectionView.indexPathsForSelectedItems?.first {
            viewController.selectedType = manager.explore(at: index).name
            viewController.selectedCity = city
        }
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Location Needed", message: "Please select a location.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func unwindLocationCancel(segue:UIStoryboardSegue){
        
    }
    
    /// Unwind action method for the **Done** button.
    ///
    /// - Parameter segue: <#segue description#>
    @IBAction func unwindLocationDone(segue: UIStoryboardSegue) {
        
        /// Check whether the source view controller is `LocationViewController`. If true, set the `selectedCity` property of `ExploreViewController` to the `LocationItem` instance stored in the `selectedCity` property of `LocationViewController`.
        if let viewController = segue.source as? LocationViewController {
            selectedCity = viewController.selectedCity
            
            /// Assign `selectedCity` to a temporary constant.
            if let location = selectedCity {
                
                /// If successful, assign the `full` property of the `LocationItem` instance to the `text` property of `headerView`.
                headerView.lblLocation.text = location.full
            }
        }
    }
}

// MARK: UICollectionViewDataSource
extension ExploreViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
        headerView = header as? ExploreHeaderView
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exploreCell", for: indexPath) as! ExploreCell
        let item = manager.explore(at: indexPath)
        cell.lblName.text = item.name
        cell.imgExplore.image = UIImage(named: item.image)
        return cell
    }
}
