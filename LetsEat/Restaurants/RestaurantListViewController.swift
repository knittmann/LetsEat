//
//  RestaurantListViewController.swift
//  LetsEat
//
//  Created by admin on 28/11/2019.
//  Copyright © 2019 MyName. All rights reserved.
//

import UIKit

class RestaurantListViewController: UIViewController,  UICollectionViewDelegate {
    
    var selectedRestaurant: RestaurantItem?
    var selectedCity: LocationItem?
    var selectedType: String?
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// Show a different list of restaurants each time the view appears onscreen depending on what location and cuisine the user
    /// picks. The list of restaurants is loaded from the corresponding location json file.
    ///
    /// - Parameter animated: Whether to animate the transition or not.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let location = selectedCity?.city, let type = selectedType else {
            return
        }
        
        print("type \(type)")
        print(RestaurantAPIManager.loadJSON(file: location))
    }
}

// MARK: Private Extension
private extension RestaurantListViewController {
    // code goes here
}

// MARK: UICollectionViewDataSource
extension RestaurantListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "restaurantCell", for: indexPath)
    }
    
}
