//
//  LocationViewController.swift
//  LetsEat
//
//  Created by admin on 03/12/2019.
//  Copyright © 2019 MyName. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let manager = LocationDataManager()
    /// Keep track of the user's selection
    var selectedCity: LocationItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    func set(selected cell: UITableViewCell, at indexPath: IndexPath) {
        
        /// Check to see whether the `selectedCity` property is set and call the `findLocation(by:)` method in `LocationDataManager`.
        if let city = selectedCity?.city {
            let data = manager.findLocation(by: city)
            
            /// If `isFound` is true, compare the cell's row with `position`. If they are the same, the checkmark for that row is set. Otherwise, it is not.
            if data.isFound {
                if indexPath.row == data.position {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            }
        }
        /// If no data is found, the checkmark is not set.
        else {
            cell.accessoryType = .none
        }
    }
}

// MARK: Private Extension
private extension LocationViewController {
    func initialize() {
        manager.fetch()
    }
}

// MARK: UITableViewDataSource
extension LocationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        manager.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as UITableViewCell
        
        /// Return a string that combines a location's city and state strings.
        cell.textLabel?.text = manager.locationItem(at: indexPath).full
        
        /// Call for each row in the table view and only set the checkmark on the row containing the selected location.
        set(selected: cell, at: indexPath)
        return cell
    }
}

// MARK: UITableViewDelegate

/// Adopt the UITableViewDelegate protocol to add a checkmark to the table row the user selects.
extension LocationViewController: UITableViewDelegate {
    
    /// Trigger the `UITableViewDelegate` when a user taps a row in the table view in `tableView(_:didSelectRowAt:)`.
    
    
    /// Add a checkmark to the table row that the user selects and assign the `LocationItem` instance to the `selectedCity`
    /// property.
    ///
    /// - Parameters:
    ///   - tableView: <#tableView description#>
    ///   - indexPath: <#indexPath description#>
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            selectedCity = manager.locationItem(at: indexPath)
            tableView.reloadData()
        }
    }
}
